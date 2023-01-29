//
//  TownIntroViewController.swift
//  FindTown
//
//  Created by 장선영 on 2023/01/29.
//

import UIKit
import FindTownCore
import FindTownUI
import RxSwift
import RxCocoa

/// 동네소개 페이지
final class TownIntroViewController: BaseViewController, UIScrollViewDelegate {
    
    // MARK: - Properties
    
    var viewModel: TownIntroViewModel?
    
    // MARK: - Views
    
    private let townIntroView = UIView()
    private let townIntroTitleLabel = FindTownLabel(text: "어떤 동네인가요?", font: .subtitle4)
    private let townIntroLabel = FindTownLabel(text: "", font: .body4, textColor: .grey6, textAlignment: .left)
    
    private let townMoodView = UIView()
    private let townMoodTitleLabel = FindTownLabel(text: "동네 분위기", font: .subtitle4)
    private let townMoodCollectionView = TownMoodCollectionView()
    
    private let trafficView = UIView()
    private let trafficTitleLabel = FindTownLabel(text: "교통", font: .subtitle4)
    private let trafficNearLabel = FindTownLabel(text: "주변 지하철 노선", font: .body4)
    private let trafficTipStackView = UIStackView()
    
    private let townRankView = UIView()
    private let townRankTitleLabel = FindTownLabel(text: "숫자로 보는 동네", font: .subtitle4)
    private let townRankInfoButton = UIButton()
    
    private let hotPlaceView = UIView()
    private let hotPlaceTitleLabel = FindTownLabel(text: "근처 핫플레이스", font: .subtitle4)
    private let hotPlaceCollectionView = HotPlaceCollectionView()
    
    // MARK: - Life Cycle
    
    init(viewModel: TownIntroViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    override func setupView() {
        self.title = "관악구 신림동"
        self.view.backgroundColor = FindTownColor.grey1.color
        self.stackView.spacing = 11
        
        [townIntroView, townMoodView, trafficView, townRankView, hotPlaceView].forEach {
            $0.backgroundColor = FindTownColor.white.color
        }
        
        [townRankView].forEach {
            $0.heightAnchor.constraint(equalToConstant: 200).isActive = true
        }
        
        townIntroLabel.text = "신림동은 20대 1인가구가 많이 살고 있어요."
        townRankInfoButton.setImage(UIImage(named: "Icon_Information"), for: .normal)
        townRankInfoButton.addTarget(self, action: #selector(tapTownRankInfoBtn), for: .touchUpInside)
        
        trafficTipStackView.axis = .horizontal
        trafficTipStackView.spacing = 4
    }
    
    override func addView() {
        super.addView()
        
        [townIntroView, townMoodView, trafficView, townRankView, hotPlaceView].forEach {
            self.stackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [townIntroTitleLabel, townIntroLabel].forEach {
            townIntroView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [townMoodTitleLabel, townMoodCollectionView].forEach {
            townMoodView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [trafficTitleLabel, trafficNearLabel, trafficTipStackView].forEach {
            trafficView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [townRankTitleLabel, townRankInfoButton].forEach {
            townRankView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [hotPlaceTitleLabel, hotPlaceCollectionView].forEach {
            hotPlaceView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    override func setLayout() {
        super.setLayout()
        
        NSLayoutConstraint.activate([
            townIntroTitleLabel.topAnchor.constraint(equalTo: townIntroView.topAnchor, constant: 33),
            townIntroTitleLabel.leadingAnchor.constraint(equalTo: townIntroView.leadingAnchor, constant: 16.0),
            townIntroLabel.topAnchor.constraint(equalTo: townIntroTitleLabel.bottomAnchor, constant: 12.0),
            townIntroLabel.leadingAnchor.constraint(equalTo: townIntroTitleLabel.leadingAnchor),
            townIntroLabel.bottomAnchor.constraint(equalTo: townIntroView.bottomAnchor, constant: -32.0)
        ])
        
        NSLayoutConstraint.activate([
            townMoodTitleLabel.topAnchor.constraint(equalTo: townMoodView.topAnchor, constant: 33),
            townMoodTitleLabel.leadingAnchor.constraint(equalTo: townMoodView.leadingAnchor, constant: 16.0),
            townMoodCollectionView.heightAnchor.constraint(equalToConstant: 35.0),
            townMoodCollectionView.topAnchor.constraint(equalTo: townMoodTitleLabel.bottomAnchor, constant: 12.0),
            townMoodCollectionView.leadingAnchor.constraint(equalTo: townMoodTitleLabel.leadingAnchor),
            townMoodCollectionView.trailingAnchor.constraint(equalTo: townMoodView.trailingAnchor, constant: -16.0),
            townMoodCollectionView.bottomAnchor.constraint(equalTo: townMoodView.bottomAnchor, constant: -32.0)
        ])
        
        NSLayoutConstraint.activate([
            trafficTitleLabel.topAnchor.constraint(equalTo: trafficView.topAnchor, constant: 33),
            trafficTitleLabel.leadingAnchor.constraint(equalTo: trafficView.leadingAnchor, constant: 16.0),
            trafficNearLabel.leadingAnchor.constraint(equalTo: trafficTitleLabel.leadingAnchor),
            trafficNearLabel.topAnchor.constraint(equalTo: trafficTitleLabel.bottomAnchor, constant: 12.0),
            trafficNearLabel.bottomAnchor.constraint(equalTo: trafficView.bottomAnchor, constant: -32.0),
            trafficTipStackView.leadingAnchor.constraint(equalTo: trafficNearLabel.trailingAnchor, constant: 8),
            trafficTipStackView.centerYAnchor.constraint(equalTo: trafficNearLabel.centerYAnchor),
            trafficTipStackView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            townRankTitleLabel.topAnchor.constraint(equalTo: townRankView.topAnchor, constant: 33),
            townRankTitleLabel.leadingAnchor.constraint(equalTo: townRankView.leadingAnchor, constant: 16.0),
            townRankInfoButton.leadingAnchor.constraint(equalTo: townRankTitleLabel.trailingAnchor, constant: 8.0),
            townRankInfoButton.centerYAnchor.constraint(equalTo: townRankTitleLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            hotPlaceTitleLabel.topAnchor.constraint(equalTo: hotPlaceView.topAnchor, constant: 33),
            hotPlaceTitleLabel.leadingAnchor.constraint(equalTo: hotPlaceView.leadingAnchor, constant: 16.0),
            hotPlaceCollectionView.heightAnchor.constraint(equalToConstant: 34.0),
            hotPlaceCollectionView.topAnchor.constraint(equalTo: hotPlaceTitleLabel.bottomAnchor, constant: 12.0),
            hotPlaceCollectionView.leadingAnchor.constraint(equalTo: hotPlaceTitleLabel.leadingAnchor),
            hotPlaceCollectionView.trailingAnchor.constraint(equalTo: hotPlaceView.trailingAnchor, constant: -16.0),
            hotPlaceCollectionView.bottomAnchor.constraint(equalTo: hotPlaceView.bottomAnchor, constant: -32.0)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        townMoodCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel?.output.townMoodDataSource
            .observe(on: MainScheduler.instance)
            .bind(to: townMoodCollectionView.rx.items(cellIdentifier: TownMoodCollectionViewCell.reuseIdentifier, cellType: TownMoodCollectionViewCell.self)) { index, item, cell in
                cell.setupCell(item)
            }
            .disposed(by: disposeBag)
        
        viewModel?.output.trafficDataSource
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { traffics in
                
                for traffic in traffics {
                    let trafficTip = TrafficTipView(type: traffic)
                    self.trafficTipStackView.addArrangedSubview(trafficTip)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel?.output.hotPlaceDataSource
            .observe(on: MainScheduler.instance)
            .bind(to: hotPlaceCollectionView.rx.items(cellIdentifier: HotPlaceCollectionViewCell.reuseIdentifier, cellType: HotPlaceCollectionViewCell.self)) { index, item, cell in
                cell.setupCell(item)
            }
            .disposed(by: disposeBag)
    }
}

private extension TownIntroViewController {
    @objc func tapTownRankInfoBtn() {
        
    }
}
