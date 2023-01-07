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
    private let addressButton: UIButton = {
        let button = UIButton()
        button.setTitle("서울시 관악구 신림동", for: .normal)
        button.setTitleColor(FindTownColor.grey7.color, for: .normal)
        button.titleLabel?.font = FindTownFont.label1.font
        button.setImage(UIImage(named: "dropDown"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()
    private let mapToggle = MapSegmentControl(items: ["인프라", "테마"])
    private let detailCategoryView = MapDetailCategoryView()
    
    lazy var categoryCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 10
        flowLayout.sectionInset = UIEdgeInsets(top: 0.0,
                                               left: 17.0,
                                               bottom: 0.0,
                                               right: 17.0)
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
        guard let viewModel = viewModel else { return }
        
        // MARK: Input
        
        favoriteButton.rx.tap
            .throttle(.seconds(10), scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                print("rightBarButton tapped")
            })
            .disposed(by: disposeBag)
        
        addressButton.rx.tap
            .subscribe(onNext: {
                print("rightBarButton tapped")
            })
            .disposed(by: disposeBag)
 
        mapToggle.rx.selectedSegmentIndex
            .bind(to: viewModel.input.segmentIndex)
            .disposed(by: disposeBag)
        
        // MARK: Output
        
        /// iconCollectionView 데이터 바인딩
        viewModel.output.dataSource.observe(on: MainScheduler.instance)
            .bind(to: categoryCollectionView.rx.items(cellIdentifier: MapCollectionViewCell.reuseIdentifier,
                                              cellType: MapCollectionViewCell.self)) { index, item, cell in
                
                cell.setupCell(image: item.image, title: item.title)
            }.disposed(by: disposeBag)
        
        /// 선택한 iconCell에 맞는 detailCategoryView 데이터 보여주게 함
        categoryCollectionView.rx.modelSelected(Category.self)
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
        
        [categoryCollectionView, detailCategoryView].forEach {
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
    }

    override func setLayout() {
        setNaviBarLayout()
        setMapViewLayout()
    }
}

// MARK: UI Details

private extension MapViewController {
    
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
            categoryCollectionView.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 16.0),
            categoryCollectionView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor),
            categoryCollectionView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 32.0)
        ])
        
        NSLayoutConstraint.activate([
            detailCategoryView.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor, constant: 16.0),
            detailCategoryView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 16.0)
        ])
    }
}

