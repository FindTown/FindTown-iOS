//
//  PlaceViewController.swift
//  FindTown
//
//  Created by 장선영 on 2023/11/08.
//

import UIKit

import FindTownCore
import FindTownUI

import SnapKit
import RxSwift
import RxCocoa

final class PlaceViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let viewModel: PlaceViewModel?
    
    // MARK: - Views
    
    private let indicator = UIActivityIndicatorView(style: .medium)
    private let addressView = UIView()
    private let addressButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(FindTownColor.grey7.color, for: .normal)
        button.titleLabel?.font = FindTownFont.label1.font
        button.setImage(UIImage(named: "dropDown"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()
    
    private let bannerCollectionView = BannerCollectionView()
    private let realTimePlaceLabel = FindTownLabel(
                                        text: "실시간 장소 제보",
                                        font: .subtitle2)
    private let themeCollectionView = CategoryCollectionView(type: .place)
    private let placeTableView = UIView()
    
    // MARK: - Life Cycle
    
    init(viewModel: PlaceViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupView() {
        self.view.backgroundColor = .white
        self.title = "플레이스"
        addressView.backgroundColor = .white
//        indicator.startAnimating()
        themeCollectionView.register(
            ThemeCollectionViewCell.self,
            forCellWithReuseIdentifier: ThemeCollectionViewCell.reuseIdentifier
        )
        // TODO: 추후 수정
        addressButton.setTitle("서울시 강남구 역삼동", for: .normal)
    }
    
    override func addView() {
        super.addView()
        
        [indicator, addressView].forEach {
            self.view.addSubview($0)
        }
        
        addressView.addSubview(addressButton)
        
        [
         bannerCollectionView,
         realTimePlaceLabel,
         themeCollectionView,
         placeTableView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        stackView.layoutMargins = UIEdgeInsets(top: 64, left: 16, bottom: 16, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.setCustomSpacing(40.0, after: bannerCollectionView)
        stackView.setCustomSpacing(14.0, after: realTimePlaceLabel)
        stackView.setCustomSpacing(24.0, after: themeCollectionView)
        placeTableView.backgroundColor = .green
    }
    
    override func setLayout() {
        super.setLayout()
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        indicator.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        addressView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeArea)
            $0.height.equalTo(54)
        }
        
        addressButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(24)
        }
    
        bannerCollectionView.snp.makeConstraints {
            $0.height.equalTo(80)
        }
        
        themeCollectionView.snp.makeConstraints {
            $0.height.equalTo(32+10)
        }
        
        placeTableView.snp.makeConstraints {
            $0.height.equalTo(500)
        }
    }
    
    override func bindViewModel() {
        addressButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel?.presentAddressSheet()
            })
            .disposed(by: disposeBag)
        
        viewModel?.output.themeDataSource
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: themeCollectionView.rx.items(
                cellIdentifier: ThemeCollectionViewCell.reuseIdentifier,
                cellType: ThemeCollectionViewCell.self)) {
                index, item, cell in
                    cell.setupCell(title: item.description)
            }.disposed(by: disposeBag)
        
        let mockData = BehaviorSubject<[UIImage]>(value: [UIImage(named: "banner1")!,
                                                          UIImage(named: "banner2")!])
        
        mockData
            .bind(to: bannerCollectionView.rx.items(
                cellIdentifier: BannerCollectionViewCell.reuseIdentifier,
                cellType: BannerCollectionViewCell.self)) {
                index, item, cell in
                    cell.setupCell(image: item)
            }.disposed(by: disposeBag)
        
        
        // TODO: 추후 수정
        themeCollectionView.selectItem(
            at: IndexPath(row: 0, section: 0),
            animated: false,
            scrollPosition: .bottom
        )
    }
}
