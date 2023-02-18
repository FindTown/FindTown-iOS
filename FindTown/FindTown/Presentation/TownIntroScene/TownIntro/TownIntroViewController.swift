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
    
    fileprivate let favoriteButton = UIBarButtonItem(image: UIImage(named: "favorite.nonselect"),
                                                     style: .plain,
                                                     target: nil,
                                                     action: nil)
    
    /// 소개
    private let townIntroView = UIView()
    private let townIntroTitleLabel = FindTownLabel(text: "어떤 동네인가요?", font: .subtitle4)
    private let townIntroLabel = FindTownLabel(text: "", font: .body4, textColor: .grey6, textAlignment: .left)
    
    /// 동네 분위기
    private let townMoodView = UIView()
    private let townMoodTitleLabel = FindTownLabel(text: "동네 분위기", font: .subtitle4)
    private let townMoodCollectionView = TownMoodCollectionView()
    
    /// 교통
    private let trafficView = UIView()
    private let trafficTitleLabel = FindTownLabel(text: "교통", font: .subtitle4)
    private let trafficNearLabel = FindTownLabel(text: "주변 지하철 노선", font: .body4)
    private let trafficTipStackView = UIStackView()
    
    /// 숫자로 보는 동네
    private let townRankView = UIView()
    private let townRankTitleLabel = FindTownLabel(text: "숫자로 보는 동네", font: .subtitle4)
    private let townRankInfoButton = UIButton()
    private let townRankScrollView = UIScrollView()
    private let townRankStackView = UIStackView()
    private let townRankToolTip = ToolTip(text: "지역 안전지수, 사회 안전지수, 서울 도시청결도\n 평가를 토대로 제공하는 정보입니다.",
                                          viewColor: .black, textColor: .white,
                                          tipLocation: .topCustom(tipXPoint: 127.0), width: 238, height: 52)
        
    /// 근처 핫플레이스
    private let hotPlaceView = UIView()
    private let hotPlaceTitleLabel = FindTownLabel(text: "근처 핫플레이스", font: .subtitle4)
    private let hotPlaceCollectionView = HotPlaceCollectionView()
    
    private let moveToMapButton = FTButton(style: .round)
    
    // MARK: - Life Cycle
    
    init(viewModel: TownIntroViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupView() {
        self.navigationItem.rightBarButtonItem = favoriteButton        
        self.stackView.backgroundColor = FindTownColor.grey1.color
        self.stackView.spacing = 11
        
        [townIntroView, townMoodView, trafficView, townRankView, hotPlaceView].forEach {
            $0.backgroundColor = FindTownColor.white.color
        }
    
        townRankInfoButton.setImage(UIImage(named: "Icon_Information"), for: .normal)
        townRankInfoButton.addTarget(self, action: #selector(tapTownRankInfoButton), for: .touchUpInside)
        
        trafficTipStackView.axis = .horizontal
        trafficTipStackView.spacing = 4
        
        townRankScrollView.showsHorizontalScrollIndicator = false
        townRankStackView.axis = .horizontal
        townRankStackView.spacing = 12
        townRankToolTip.dismiss()
        addTapGesture()
        
        moveToMapButton.setTitle("동네지도로 이동", for: .normal)
        moveToMapButton.setImage(UIImage(named: "map_icon"), for: .normal)
        moveToMapButton.changesSelectionAsPrimaryAction = false
        moveToMapButton.isSelected = true
        
        self.viewModel?.getTownIntroData()
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
        
        [townRankTitleLabel, townRankInfoButton, townRankScrollView, townRankToolTip].forEach {
            townRankView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        townRankScrollView.addSubview(townRankStackView)
        townRankStackView.translatesAutoresizingMaskIntoConstraints = false
        
        [hotPlaceTitleLabel, hotPlaceCollectionView].forEach {
            hotPlaceView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        self.view.addSubview(moveToMapButton)
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
            townRankInfoButton.centerYAnchor.constraint(equalTo: townRankTitleLabel.centerYAnchor),
            townRankScrollView.topAnchor.constraint(equalTo: townRankTitleLabel.bottomAnchor, constant: 12.0),
            townRankScrollView.leadingAnchor.constraint(equalTo: townRankTitleLabel.leadingAnchor),
            townRankScrollView.centerXAnchor.constraint(equalTo: townRankView.centerXAnchor),
            townRankScrollView.heightAnchor.constraint(equalToConstant: 118.0),
            townRankScrollView.bottomAnchor.constraint(equalTo: townRankView.bottomAnchor, constant: -32.0),
            
            townRankStackView.heightAnchor.constraint(equalTo: townRankScrollView.frameLayoutGuide.heightAnchor),
            townRankStackView.topAnchor.constraint(equalTo: townRankScrollView.contentLayoutGuide.topAnchor),
            townRankStackView.leadingAnchor.constraint(equalTo: townRankScrollView.contentLayoutGuide.leadingAnchor),
            townRankStackView.trailingAnchor.constraint(equalTo: townRankScrollView.contentLayoutGuide.trailingAnchor),
            townRankStackView.bottomAnchor.constraint(equalTo: townRankScrollView.contentLayoutGuide.bottomAnchor),
            
            townRankToolTip.topAnchor.constraint(equalTo: townRankInfoButton.bottomAnchor, constant: 10.0),
            townRankToolTip.leadingAnchor.constraint(equalTo: townRankTitleLabel.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            hotPlaceTitleLabel.topAnchor.constraint(equalTo: hotPlaceView.topAnchor, constant: 33),
            hotPlaceTitleLabel.leadingAnchor.constraint(equalTo: hotPlaceView.leadingAnchor, constant: 16.0),
            hotPlaceCollectionView.heightAnchor.constraint(equalToConstant: 34.0),
            hotPlaceCollectionView.topAnchor.constraint(equalTo: hotPlaceTitleLabel.bottomAnchor, constant: 12.0),
            hotPlaceCollectionView.leadingAnchor.constraint(equalTo: hotPlaceTitleLabel.leadingAnchor),
            hotPlaceCollectionView.trailingAnchor.constraint(equalTo: hotPlaceView.trailingAnchor, constant: -16.0),
            hotPlaceCollectionView.bottomAnchor.constraint(equalTo: hotPlaceView.bottomAnchor, constant: -105.0)
        ])
        
        NSLayoutConstraint.activate([
            moveToMapButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            moveToMapButton.widthAnchor.constraint(equalToConstant: 140.0),
            moveToMapButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24.0)
        ])
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        townMoodCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        // MARK: Input
        
        favoriteButton.rx.tap
            .scan(false) { (lastState, newValue) in
                  !lastState
            }
            .subscribe(onNext: { [weak self] isFavorite in
                self?.rx.isFavoriteCity.onNext(isFavorite)
                self?.viewModel?.input.favoriteButtonTrigger.onNext(isFavorite)
                if isFavorite {
                    self?.showToast(message: "찜 목록에 추가 되었어요")
                }
            })
            .disposed(by: disposeBag)
        
        moveToMapButton.rx.tap
            .bind { [weak self] in
                self?.viewModel?.input.moveToMapButtonTrigger.onNext(())
            }
            .disposed(by: disposeBag)
        
        // MARK: Output
        
        viewModel?.output.isFavorite
            .bind(to: rx.isFavoriteCity)
            .disposed(by: disposeBag)
        
        viewModel?.output.townTitle
            .subscribe(onNext: { townTitle in
                self.title = townTitle
            })
            .disposed(by: disposeBag)
        
        viewModel?.output.townExplanation
            .subscribe(onNext: { townExplanation in
                self.townIntroLabel.text = townExplanation
            })
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
        
        viewModel?.output.townRankDataSource
            .observe(on: MainScheduler.instance)
            .subscribe(onNext:  { dataList in
                for data in dataList {
                    let rankView = TownRankView(data: data)
                    self.townRankStackView.addArrangedSubview(rankView)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel?.output.errorNotice
            .subscribe { [weak self] _ in
                self?.showErrorNoticeAlertPopUp(message: "네트워크 오류가 발생하였습니다.", buttonText: "확인")
            }
            .disposed(by: disposeBag)
    }
}

private extension TownIntroViewController {
    
    @objc func tapTownRankInfoButton() {
        townRankToolTip.alpha = 1.0
    }
    
    func addTapGesture() {
        let backViewTap = UITapGestureRecognizer(target: self, action: #selector(backViewTapped(_:)))
        backViewTap.cancelsTouchesInView = false
        view.addGestureRecognizer(backViewTap)
    }
    
    @objc func backViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        let backViewTappedLocation = tapRecognizer.location(in: self.townRankToolTip)
        if townRankToolTip.point(inside: backViewTappedLocation, with: nil) == false {
            townRankToolTip.dismiss()
        }
    }
}

extension Reactive where Base: TownIntroViewController {
    
    var isFavoriteCity: Binder<Bool> {
        return Binder(self.base) { (viewController, isSelect) in
            if isSelect {
                viewController.favoriteButton.image = UIImage(named: "favorite.select")
                viewController.favoriteButton.tintColor = FindTownColor.orange.color
            } else {
                viewController.favoriteButton.image = UIImage(named: "favorite.nonselect")
                viewController.favoriteButton.tintColor = FindTownColor.grey4.color
            }
        }
    }
}
