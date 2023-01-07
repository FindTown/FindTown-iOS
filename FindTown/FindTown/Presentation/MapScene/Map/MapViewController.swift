//
//  MapViewController.swift
//  FindTown
//
//  Created by 이호영 on 2022/12/25.
//

import UIKit
import FindTownCore
import FindTownUI
import NMapsMap
import RxSwift
import RxCocoa

final class MapViewController: BaseViewController {
    
    // MARK: - Properties
    
    var viewModel: MapViewModel?
    
    // MARK: - Views
    
    private let mapView = NMFMapView()
    private let naviBarSubView = UIView()
    private let favoriteButton = UIBarButtonItem(image: UIImage(named: "favoriteBtn"),
                                         style: .plain,
                                         target: nil,
                                         action: nil)
    private let addressButton = UIButton()
    private let mapToggle = MapSegmentControl(items: ["인프라", "테마"])
    private let detailCategoryView = MapDetailCategoryView()
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 8
        flowLayout.sectionInset = UIEdgeInsets(top: 0.0,
                                               left: 17.0,
                                               bottom: 0.0,
                                               right: 82.0)
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        collectionView.register(MapCollectionViewCell.self,
                                forCellWithReuseIdentifier: MapCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    // MARK: - Life Cycle
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    override func bindViewModel() {
        
        // MARK: Input
        
        favoriteButton.rx.tap
            .throttle(.seconds(10), scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                print("rightBarButton tapped")
            })
            .disposed(by: disposeBag)
        
        addressButton.rx.tap
            .bind { [weak self] in
                self?.viewModel?.presentAddressPopup()
            }
            .disposed(by: disposeBag)
 
        // MARK: Output
        
        /// iconCollectionView 데이터 바인딩
        viewModel?.dataSource.observe(on: MainScheduler.instance)
            .bind(to: collectionView.rx.items(cellIdentifier: MapCollectionViewCell.reuseIdentifier,
                                              cellType: MapCollectionViewCell.self)) { index, item, cell in
                
                cell.setupCell(image: item.image, title: item.title)
            }.disposed(by: disposeBag)
        
        /// 선택한 iconCell에 맞는 detailCategoryView 데이터 보여주게 함
        collectionView.rx.modelSelected(Category.self)
            .map { category in
                return category.detailCategories
            }
            .subscribe(onNext: { detailCategories in
                self.detailCategoryView.isHidden = false
                self.detailCategoryView.setStackView(data: detailCategories)
            })
            .disposed(by: disposeBag)
        
    }

    override func addView() {
        [mapView, naviBarSubView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        
        [addressButton,mapToggle].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            naviBarSubView.addSubview($0)
        }
        
        [collectionView, detailCategoryView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mapView.addSubview($0)
        }
    }
    
    override func setupView() {
        self.title = "동네 지도"
        view.backgroundColor = FindTownColor.back2.color
        
        naviBarSubView.backgroundColor = FindTownColor.white.color
        self.navigationItem.rightBarButtonItem = favoriteButton
        self.detailCategoryView.isHidden = true
        setUpAddressButton()
    }

    override func setLayout() {
        setNaviBarLayout()
        setMapViewLayout()
    }
}

// MARK: UI Details

private extension MapViewController {
    
    func setUpAddressButton() {
        addressButton.setTitle("00시 00구 00동", for: .normal)
        addressButton.setTitleColor(FindTownColor.grey7.color, for: .normal)
        addressButton.titleLabel?.font = FindTownFont.label1.font
        addressButton.setImage(UIImage(named: "dropDown"), for: .normal)
        addressButton.semanticContentAttribute = .forceRightToLeft
    }
    
    func setNaviBarLayout() {
        
        let view = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            naviBarSubView.topAnchor.constraint(equalTo: view.topAnchor),
            naviBarSubView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            naviBarSubView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            naviBarSubView.heightAnchor.constraint(equalToConstant: 54.0)
        ])
        
        NSLayoutConstraint.activate([
            addressButton.leadingAnchor.constraint(equalTo: naviBarSubView.leadingAnchor, constant: 16.0),
            addressButton.bottomAnchor.constraint(equalTo: naviBarSubView.bottomAnchor, constant: -8.0)
        ])
        
        NSLayoutConstraint.activate([
            mapToggle.centerYAnchor.constraint(equalTo: naviBarSubView.centerYAnchor),
            mapToggle.trailingAnchor.constraint(equalTo: naviBarSubView.trailingAnchor, constant: -16.0)
        ])
    }
    
    func setMapViewLayout() {
        
        let view = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: naviBarSubView.bottomAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 16.0),
            collectionView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 32.0)
        ])
        
        NSLayoutConstraint.activate([
            detailCategoryView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16.0),
            detailCategoryView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 16.0)
        ])
    }
}
