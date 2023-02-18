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

typealias Coordinates = [[Double]]

final class MapViewController: BaseViewController {
    
    // MARK: - Properties
    
    var viewModel: MapViewModel?
    
    // MARK: - Views
    
    private let mapView = NMFMapView()
    private let naviBarSubView = UIView()
    fileprivate let favoriteButton = UIBarButtonItem(image: UIImage(named: "favorite.nonselect"),
                                         style: .plain,
                                         target: nil,
                                         action: nil)
    private let addressButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(FindTownColor.grey7.color, for: .normal)
        button.titleLabel?.font = FindTownFont.label1.font
        button.setImage(UIImage(named: "dropDown"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()
    private let mapToggle = MapSegmentControl(items: ["인프라", "테마"])
    fileprivate let detailCategoryView = MapDetailCategoryView()
    private let categoryCollectionView = CategoryCollectionView()
    fileprivate let storeCollectionView = StoreCollectionView()
    private let moveToIntroduceButton: FTButton = {
        let button = FTButton(style: .round)
        button.setTitle("동네 소개로 이동", for: .normal)
        button.setImage(UIImage(named: "chip.chat"), for: .normal)
        button.changesSelectionAsPrimaryAction = false
        return button
    }()
    
    var currentIndex: CGFloat = 0 {
        didSet {
            let index = Int(self.currentIndex)
            print(themaStores[index])
            self.setStoreMarker(selectStore: themaStores[index])
        }
    }
    let isAnonymous: Bool
    
    // MARK: Map property
    
    var villagePolygonOverlay: NMFPolygonOverlay?
    var isFirstShowingVillage: Bool = true
    var mapTransition: MapTransition
    var themaStores: [ThemaStore] = []
    var markers: [NMFMarker] = []
    
    // MARK: - Life Cycle
    
    init(viewModel: MapViewModel, mapTransition: MapTransition, isAnonymous: Bool) {
        self.viewModel = viewModel
        self.mapTransition = mapTransition
        self.isAnonymous = isAnonymous
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    override func bindViewModel() {
        // MARK: Input
        guard let viewModel = viewModel else {
            return
        }
        
        favoriteButton.rx.tap
            .scan(false) { (lastState, newValue) in
                  !lastState
            }
            .subscribe(onNext: { [weak self] isFavorite in
                self?.rx.isFavoriteCity.onNext(isFavorite)
                self?.viewModel?.input.didTapFavoriteButton.onNext(isFavorite)
                if isFavorite {
                    self?.showToast(message: "찜 목록에 추가 되었어요")
                }
            })
            .disposed(by: disposeBag)
        
        addressButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel?.presentAddressSheet()
            })
            .disposed(by: disposeBag)
 
        mapToggle.rx.selectedSegmentIndex
            .bind(to: self.rx.mapCategoryIndex)
            .disposed(by: disposeBag)
        
        // MARK: Output
        
        /// iconCollectionView 데이터 바인딩
        viewModel.output.categoryDataSource.observe(on: MainScheduler.instance)
            .bind(to: categoryCollectionView.rx.items(cellIdentifier: MapCategoryCollectionViewCell.reuseIdentifier,
                                              cellType: MapCategoryCollectionViewCell.self)) { index, item, cell in
                cell.setupCell(image: item.image, title: item.description)
            }.disposed(by: disposeBag)
        
        Observable.combineLatest(viewModel.output.categoryDataSource, viewModel.output.city)
            .bind { [weak self] categories, city in
                if let infraCategory = categories[0] as? InfraCategory {
                    //
                } else if let themaCategory = categories[0] as? ThemaCategory {
                    self?.viewModel?.getThemaData(category: themaCategory, city: city)
                }
                self?.categoryCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .left)
                
        }
        .disposed(by: disposeBag)
        
        /// iconCollectionView 데이터 바인딩
        viewModel.output.storeDataSource.observe(on: MainScheduler.instance)
            .bind(to: storeCollectionView.rx.items(cellIdentifier: MapStoreCollectionViewCell.reuseIdentifier,
                                              cellType: MapStoreCollectionViewCell.self)) { index, item, cell in
                cell.setupCell(store: item)
                cell.delegate = self
            }.disposed(by: disposeBag)
        
        viewModel.output.storeDataSource
            .bind { [weak self] stores in
                self?.themaStores = stores

                self?.setStoreMarker(selectStore: stores[0])
                self?.storeCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
                self?.currentIndex = 0
        }
        .disposed(by: disposeBag)
        
        /// 선택한 iconCell에 맞는 detailCategoryView 데이터 보여주게 함
        Observable.combineLatest(categoryCollectionView.rx.modelSelected(Category.self), viewModel.output.city)
            .subscribe(onNext: { [weak self] categoty, city in
                if let infraCategory = categoty as? InfraCategory {
                    print(infraCategory)
                    print(city)
                } else if let themaCategory = categoty as? ThemaCategory {
                    self?.viewModel?.getThemaData(category: themaCategory, city: city)
                }
//                self.detailCategoryView.setStackView(data: [])
            })
            .disposed(by: disposeBag)
        
        storeCollectionView.rx.modelSelected(ThemaStore.self)
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] store in
                guard let storeIndex = self?.themaStores.firstIndex(of: store) else {
                    return
                }
                self?.setStoreMarker(selectStore: store)
                self?.storeCollectionView.scrollToItem(at: IndexPath(item: storeIndex, section: 0), at: .left, animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.city
            .subscribe(onNext: { [weak self] city in
                self?.addressButton.setTitle(city.description, for: .normal)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.cityBoundaryCoordinates
            .subscribe(onNext: { [weak self] boundaryCoordinates in
                guard let isFirstShowingVillage = self?.isFirstShowingVillage else {
                    return
                }
                if isFirstShowingVillage {
                    self?.setVillageCooridnateOverlay(boundaryCoordinates, animation: false)
                } else {
                    self?.setVillageCooridnateOverlay(boundaryCoordinates, animation: true)
                }
                
                self?.isFirstShowingVillage = false
            })
            .disposed(by: disposeBag)
            
        viewModel.input.segmentIndex
            .bind { [weak self] index in
                if index == 0 {
                    self?.viewModel?.output.categoryDataSource.onNext(InfraCategory.allCases)
                } else {
                    self?.viewModel?.output.categoryDataSource.onNext(ThemaCategory.allCases)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.output.isFavoriteCity
            .bind(to: rx.isFavoriteCity)
            .disposed(by: disposeBag)
        
        viewModel.output.errorNotice
            .subscribe { [weak self] _ in
                self?.showErrorNoticeAlertPopUp(message: "네트워크 오류가 발생하였습니다.", buttonText: "확인")
            }
            .disposed(by: disposeBag)
        
    }

    override func addView() {
        [mapView, naviBarSubView, moveToIntroduceButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        
        [addressButton,mapToggle].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            naviBarSubView.addSubview($0)
        }
        
        [categoryCollectionView, detailCategoryView, storeCollectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mapView.addSubview($0)
        }
    }
    
    override func setupView() {
        self.title = "동네 지도"
        view.backgroundColor = FindTownColor.back2.color
        
        naviBarSubView.backgroundColor = FindTownColor.white.color
        if isAnonymous == false {
            favoriteButton.tintColor = FindTownColor.grey4.color
            self.navigationItem.rightBarButtonItem = favoriteButton
        }
        
        self.storeCollectionView.delegate = self
        self.viewModel?.setCity()
        setMapZoomLevel()
        setMapLayerGrounp()
    }

    override func setLayout() {
        setNaviBarLayout()
        setMapViewLayout()
        setLayoutByTransition()
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
            categoryCollectionView.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 6.0),
            categoryCollectionView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor),
            categoryCollectionView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 57)
        ])
        
        NSLayoutConstraint.activate([
            detailCategoryView.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor, constant: 1.0),
            detailCategoryView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 16.0)
        ])
    }
    
    func setLayoutByTransition() {
        let storeCollectionViewBottomConstraint: Int
        let moveToIntroduceButtonBottomConstraint: Int
        
        switch mapTransition {
        case .tapBar:
            storeCollectionViewBottomConstraint = -84
            moveToIntroduceButtonBottomConstraint = -24
        case .push:
            storeCollectionViewBottomConstraint = -107
            moveToIntroduceButtonBottomConstraint = -47
        }
        
        NSLayoutConstraint.activate([
            storeCollectionView.heightAnchor.constraint(equalToConstant: 142),
            storeCollectionView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor),
            storeCollectionView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor),
            storeCollectionView.bottomAnchor.constraint(equalTo: mapView.bottomAnchor,
                                                        constant: CGFloat(storeCollectionViewBottomConstraint))
        ])
        
        NSLayoutConstraint.activate([
            moveToIntroduceButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            moveToIntroduceButton.widthAnchor.constraint(equalToConstant: 140.0),
            moveToIntroduceButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                          constant: CGFloat(moveToIntroduceButtonBottomConstraint))
        ])
    }
}

// MARK: MapView

extension MapViewController {
    
    func setCameraPosition(latitude: Double, longitude: Double, zoomLevel: Double, animation: Bool) {
        let cameraPosition = NMFCameraPosition(NMGLatLng(lat: latitude, lng: longitude), zoom: zoomLevel, tilt: 0, heading: 0)
        let cameraUpdate = NMFCameraUpdate(position: cameraPosition)
        
        if animation {
            cameraUpdate.animation = .easeIn
            cameraUpdate.animationDuration = 0.2
        }
        mapView.moveCamera(cameraUpdate)
    }
    
    func setMapZoomLevel() {
        mapView.minZoomLevel = 10.0
        mapView.maxZoomLevel = 18.0
                
        // 서울 인근 카메라 제한
        mapView.extent = NMGLatLngBounds(southWestLat: 37.40, southWestLng: 126.70, northEastLat: 37.60, northEastLng: 127.10)
    }
    
    func setMapLayerGrounp() {
        mapView.setLayerGroup(NMF_LAYER_GROUP_MOUNTAIN, isEnabled: true)
        mapView.setLayerGroup(NMF_LAYER_GROUP_TRANSIT, isEnabled: true)
    }
    
    func setVillageCooridnateOverlay(_ boundaryCoordinates: Coordinates, animation: Bool = true) {
        villagePolygonOverlay?.mapView = nil
        
        setCameraPosition(latitude: boundaryCoordinates[0][1],
                          longitude: boundaryCoordinates[0][0],
                          zoomLevel: 14,
                          animation: animation)

        let villagePolygon = NMGPolygon(ring: NMGLineString(points: MapConstant.koreaBoundaryCoordinates.convertNMLatLng()), interiorRings: [NMGLineString(points: boundaryCoordinates.convertNMLatLng())])
        villagePolygonOverlay = NMFPolygonOverlay(villagePolygon as! NMGPolygon<AnyObject>)
        
        villagePolygonOverlay?.fillColor = UIColor(red: 26, green: 26, blue: 26).withAlphaComponent(0.2)
        villagePolygonOverlay?.mapView = mapView
    }
    
    func setStoreMarker(selectStore: ThemaStore) {
        clearMarker()
        
        for (index, store) in themaStores.enumerated() {
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: store.longitude, lng: store.latitude)
            if store == selectStore {
                marker.iconImage = NMFOverlayImage(name: "marker.select")
                self.setCameraPosition(latitude: store.longitude,
                                       longitude: store.latitude,
                                       zoomLevel: 15,
                                       animation: true)
            } else {
                marker.iconImage = NMFOverlayImage(name: "marker.nonSelect")
            }
            marker.width = 20
            marker.height = 20
            
            marker.mapView = mapView
            
            marker.touchHandler = { (overlay: NMFOverlay) -> Bool in
                self.storeCollectionView.selectItem(at: IndexPath(item: index, section: 0),
                                                    animated: true,
                                                    scrollPosition: .left)
                self.setStoreMarker(selectStore: store)
                return true
            }
            
            markers.append(marker)
        }
    }
    
    func clearMarker() {
        for marker in self.markers {
            marker.mapView = nil
        }
        self.markers.removeAll()
    }
}

extension MapViewController: MapStoreCollectionViewCellDelegate {
    func didTapInformationUpdateButton() {
        print("informationUpdate tap")
    }
    
    func didTapCopyButton(text: String) {
        UIPasteboard.general.string = text
        self.showToast(message: "클립보드에 복사되었습니다.")
    }
}

extension MapViewController: UIScrollViewDelegate, UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        guard let layout = self.storeCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        var roundedIndex = round(index)
        
        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            roundedIndex = floor(index)
        } else if scrollView.contentOffset.x < targetContentOffset.pointee.x {
            roundedIndex = ceil(index)
        } else {
            roundedIndex = round(index)
        }
        
        if currentIndex > roundedIndex {
            currentIndex -= 1
            roundedIndex = currentIndex
        } else if currentIndex < roundedIndex {
            currentIndex += 1
            roundedIndex = currentIndex
        }
    
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}

extension Reactive where Base: MapViewController {
    
    var mapCategoryIndex: Binder<Int> {
        return Binder(self.base) { (viewController, index) in
            if index == 0 {
                viewController.storeCollectionView.isHidden = true
                viewController.detailCategoryView.isHidden = false
            } else {
                viewController.storeCollectionView.isHidden = false
                viewController.detailCategoryView.isHidden = true
            }
            viewController.viewModel?.input.segmentIndex.accept(index)
        }
    }
    
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

fileprivate extension Coordinates {
    func convertNMLatLng() -> [NMGLatLng] {
        return self.map { coordinate in
            NMGLatLng(lat: coordinate[1], lng: coordinate[0])
        }
    }
}
