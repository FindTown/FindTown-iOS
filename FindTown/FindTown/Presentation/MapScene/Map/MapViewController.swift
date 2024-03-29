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
import SnapKit

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
    private let emptyDataInformLabel = InformLabel(text: "근처에 해당하는 장소가 없습니다.")
    private let addPlaceButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_post"), for: .normal)
        return button
    }()
    
    private var currentIndex: CGFloat = 0 {
        didSet {
            let index = Int(self.currentIndex)
            self.setThemaStoreMarker(selectStore: themaStores[index])
        }
    }
    
    // MARK: Property
    
    var selectedIndex: Int = 0
    
    // MARK: Map property
    
    var villagePolygonOverlay: NMFPolygonOverlay?
    var isFirstShowingVillage: Bool = true
    var mapTransition: MapTransition
    var themaStores: [ThemaStore] = []
    var markers: [NMFMarker] = []
    var villageboundaryCoordinates: Coordinates = []
    
    // MARK: - Life Cycle
    
    init(viewModel: MapViewModel, mapTransition: MapTransition) {
        self.viewModel = viewModel
        self.mapTransition = mapTransition
        
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
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel?.changeFavoriteStauts()
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
        
        moveToIntroduceButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let cityCode = self?.viewModel?.cityCode else {
                    return
                }
                self?.viewModel?.gotoIntroduce(cityCode: cityCode)
            })
            .disposed(by: disposeBag)
        
        addPlaceButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                let nextVC = BaseNavigationController(rootViewController: SearchPlaceViewController())
                nextVC.modalPresentationStyle = .fullScreen
                self?.present(nextVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        // MARK: Output
        
        /// iconCollectionView 데이터 바인딩
        viewModel.output.categoryDataSource.observe(on: MainScheduler.instance)
            .bind(to: categoryCollectionView.rx.items(cellIdentifier: MapCategoryCollectionViewCell.reuseIdentifier,
                                              cellType: MapCategoryCollectionViewCell.self)) { index, item, cell in
                cell.setupCell(image: item.image, title: item.description)
                if index == self.selectedIndex {
                    self.categoryCollectionView.selectItem(at: IndexPath(item: self.selectedIndex, section: 0), animated: true, scrollPosition: .bottom)
                    cell.isSelected = true
                }
            }.disposed(by: disposeBag)
        
        viewModel.output.categoryDataSource.observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] categories in
                if let firstInfraCategory = categories[0] as? InfraCategory {
                    self?.viewModel?.getInfraData(category: firstInfraCategory)
                    self?.detailCategoryView.setStackView(subCategories: firstInfraCategory.subCatrgories)
                } else if let firstThemaCategory = categories[0] as? ThemaCategory {
                    self?.viewModel?.getThemaData(category: firstThemaCategory)
                }
            }).disposed(by: disposeBag)
        
        /// iconCollectionView 데이터 바인딩
        viewModel.output.themaStoreDataSource.observe(on: MainScheduler.instance)
            .bind(to: storeCollectionView.rx.items(cellIdentifier: MapStoreCollectionViewCell.reuseIdentifier,
                                              cellType: MapStoreCollectionViewCell.self)) { index, item, cell in
                cell.setupCell(store: item)
                cell.delegate = self
            }.disposed(by: disposeBag)
        
        viewModel.output.themaStoreDataSource
            .bind { [weak self] stores in
                if stores.isEmpty == false {
                    self?.themaStores = stores
                    self?.showFirstThemaStore(store: stores[0])
                    self?.emptyDataInformLabel.isHidden = true
                } else {
                    DispatchQueue.main.async {
                        self?.clearMarker()
                        self?.showEntireVillage()
                        self?.emptyDataInformLabel.isHidden = false
                    }
                }
        }
        .disposed(by: disposeBag)
        
        viewModel.output.infraStoreDataSource
            .bind { [weak self] stores in
                if stores.isEmpty == false {
                    self?.setInfraStoreMarker(selectStore: nil, stores: stores)
                    self?.emptyDataInformLabel.isHidden = true
                } else {
                    DispatchQueue.main.async {
                        self?.clearMarker()
                        self?.showEntireVillage()
                        self?.emptyDataInformLabel.isHidden = false
                    }
                }
        }
        .disposed(by: disposeBag)
        
        /// 선택한 iconCell에 맞는 detailCategoryView 데이터 보여주게 함
        categoryCollectionView.rx.modelSelected(Category.self)
            .subscribe(onNext: { [weak self] categoty in
                if let infraCategory = categoty as? InfraCategory {
                    if let selectedIndex = InfraCategory.allCases.firstIndex(of: infraCategory) {
                        self?.selectedIndex = selectedIndex
                    }
                    self?.viewModel?.getInfraData(category: infraCategory)
                    self?.detailCategoryView.setStackView(subCategories: infraCategory.subCatrgories)
                } else if let themaCategory = categoty as? ThemaCategory {
                    if let selectedIndex = ThemaCategory.allCases.firstIndex(of: themaCategory) {
                        self?.selectedIndex = selectedIndex
                    }
                    self?.viewModel?.getThemaData(category: themaCategory)
                }
            })
            .disposed(by: disposeBag)
        
        storeCollectionView.rx.modelSelected(ThemaStore.self)
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] store in
                self?.setThemaStoreMarker(selectStore: store)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.city
            .subscribe(onNext: { [weak self] city in
                guard let cityCode = CityCode(county: city.county, village: city.village)?.rawValue else {
                    return
                }
                self?.viewModel?.cityCode = cityCode
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
            
        Observable.combineLatest(viewModel.input.segmentIndex, viewModel.output.city.distinctUntilChanged())
            .bind { [weak self] index, city in
                self?.selectedIndex = 0
                if index == 0 {
                    self?.viewModel?.output.categoryDataSource.onNext(InfraCategory.allCases)
                } else {
                    self?.viewModel?.output.categoryDataSource.onNext(ThemaCategory.allCases)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.output.isFavoriteCity
            .subscribe(onNext: { [weak self] isFavorite in
                self?.rx.isFavoriteCity.onNext(isFavorite)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.changeFavoriteStauts
            .subscribe(onNext: { [weak self] isFavorite in
                if isFavorite {
                    self?.showToastMessgeWithMap(with: "찜 목록에 추가 되었어요.")
                } else {
                    self?.showToastMessgeWithMap(with: "찜 목록에서 삭제되었어요.")
                }
                self?.rx.isFavoriteCity.onNext(isFavorite)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.errorNotice
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                self?.showErrorNoticeAlertPopUp(message: "네트워크 오류가 발생하였습니다.", buttonText: "확인")
            }
            .disposed(by: disposeBag)
        
    }

    override func addView() {
        [mapView, naviBarSubView, moveToIntroduceButton, addPlaceButton, emptyDataInformLabel].forEach {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel?.setCity(cityCode: viewModel?.cityCode)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func setupView() {
        self.title = "동네 지도"
        view.backgroundColor = FindTownColor.back2.color
        
        naviBarSubView.backgroundColor = FindTownColor.white.color
        if UserDefaultsSetting.isAnonymous == false {
            favoriteButton.tintColor = FindTownColor.grey4.color
            self.navigationItem.rightBarButtonItem = favoriteButton
        }
        
        self.storeCollectionView.delegate = self
        self.emptyDataInformLabel.isHidden = true
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
            mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
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
        let screenToHeight = UIScreen.main.bounds.height
        let storeCollectionViewBottomConstraint: Double
        let moveToIntroduceButtonBottomConstraint: Double
        let emptyDataInformLabelBottomConstraint: Double
        
        switch mapTransition {
        case .tapBar:
            storeCollectionViewBottomConstraint = -0.185 * screenToHeight
            moveToIntroduceButtonBottomConstraint = -0.022 * screenToHeight
            emptyDataInformLabelBottomConstraint = -0.092 * screenToHeight
        case .push:
            storeCollectionViewBottomConstraint = -0.131 * screenToHeight
            moveToIntroduceButtonBottomConstraint = -0.03 * screenToHeight
            emptyDataInformLabelBottomConstraint = -0.101 * screenToHeight
        }
        
        NSLayoutConstraint.activate([
            storeCollectionView.heightAnchor.constraint(equalToConstant: 165),
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
        
        NSLayoutConstraint.activate([
            emptyDataInformLabel.heightAnchor.constraint(equalToConstant: 44),
            emptyDataInformLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 12),
            emptyDataInformLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -12),
            emptyDataInformLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                          constant: CGFloat(emptyDataInformLabelBottomConstraint))
        ])
        
        addPlaceButton.snp.makeConstraints {
            $0.width.height.equalTo(60)
            $0.leading.equalTo(moveToIntroduceButton.snp.trailing).offset(3)
            $0.centerY.equalTo(moveToIntroduceButton)
        }
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
        
        self.villageboundaryCoordinates = boundaryCoordinates
        showEntireVillage()

        let villagePolygon = NMGPolygon(ring: NMGLineString(points: MapConstant.koreaBoundaryCoordinates.convertNMLatLng()), interiorRings: [NMGLineString(points: boundaryCoordinates.convertNMLatLng())])
        villagePolygonOverlay = NMFPolygonOverlay(villagePolygon as! NMGPolygon<AnyObject>)
        
        villagePolygonOverlay?.fillColor = UIColor(red: 26, green: 26, blue: 26).withAlphaComponent(0.2)
        villagePolygonOverlay?.mapView = mapView
    }
    
    func showEntireVillage() {
        let centerPoint = villageboundaryCoordinates.calculateCenterPoint()
        let size = villageboundaryCoordinates.calculatePolygonSize()
        
        setCameraPosition(latitude: centerPoint.latitude,
                          longitude: centerPoint.longitude,
                          zoomLevel: calculateZoomLevel(by: size),
                          animation: true)
    }
    
    func setThemaStoreMarker(selectStore: ThemaStore) {
        clearMarker()
        
        guard let storeIndex = self.themaStores.firstIndex(of: selectStore) else {
            return
        }
        self.storeCollectionView.scrollToItem(at: IndexPath(item: storeIndex, section: 0), at: .left, animated: true)
        
        for (index, store) in themaStores.enumerated() {
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: store.latitude, lng: store.longitude)
            if store == selectStore {
                marker.zIndex = 1
                marker.captionText = store.name
                marker.width = 28
                marker.height = 28
                self.setCameraPosition(latitude: store.latitude,
                                       longitude: store.longitude,
                                       zoomLevel: self.mapView.zoomLevel,
                                       animation: true)
            } else {
                marker.width = 24
                marker.height = 24
                marker.zIndex = -1
            }
            let view = MapThemaIconView(store: store)
            view.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
            let image = view.asImage()
            marker.iconImage = NMFOverlayImage(image: image ?? store.category.image!)
            marker.mapView = mapView
            
            marker.touchHandler = { (overlay: NMFOverlay) -> Bool in
                self.storeCollectionView.selectItem(at: IndexPath(item: index, section: 0),
                                                    animated: true,
                                                    scrollPosition: .left)
                self.setThemaStoreMarker(selectStore: store)
                return true
            }
            
            markers.append(marker)
        }
    }
    
    func setInfraStoreMarker(selectStore: InfraStore?, stores: [InfraStore]) {
        clearMarker()
        
        for store in stores {
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: store.latitude, lng: store.longitude)
            if let selectStore = selectStore,
                store == selectStore {
                
                marker.zIndex = 1
                marker.captionText = store.name
                marker.width = 28
                marker.height = 28
                self.setCameraPosition(latitude: store.latitude,
                                       longitude: store.longitude,
                                       zoomLevel: self.mapView.zoomLevel,
                                       animation: true)
            } else {
                marker.width = 24
                marker.height = 24
                marker.zIndex = -1
            }
            let view = MapInfraIconView(store: store)
            view.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
            let image = view.asImage()
            marker.iconImage = NMFOverlayImage(image: image ?? UIImage(named: store.subCategory.imageName)!)
            marker.mapView = mapView
            marker.touchHandler = { (overlay: NMFOverlay) -> Bool in
                self.setInfraStoreMarker(selectStore: store, stores: stores)
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
    
    func showFirstThemaStore(store: ThemaStore) {
        self.setThemaStoreMarker(selectStore: store)
        self.currentIndex = 0
    }
    
    func calculateZoomLevel(by size: Double) -> Double {
        switch size {
        case ..<2:
            return 14.2
        case ..<4:
            return 13.8
        case ..<6:
            return 13.2
        default:
            return 13
        }
    }
}

extension MapViewController: MapStoreCollectionViewCellDelegate {
    func didTapInformationUpdateButton() {
        self.viewModel?.presentInformationUpdateScene()
    }
    
    func didTapCopyButton(text: String) {
        UIPasteboard.general.string = text
        showToastMessgeWithMap(with: "클립보드에 복사되었습니다.")
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
        return Binder(self.base) { (viewController, isFavorite) in
            DispatchQueue.main.async {
                if isFavorite {
                    viewController.favoriteButton.image = UIImage(named: "favorite.select")
                    viewController.favoriteButton.tintColor = FindTownColor.orange.color
                } else {
                    viewController.favoriteButton.image = UIImage(named: "favorite.nonselect")
                    viewController.favoriteButton.tintColor = FindTownColor.grey4.color
                }
            }
        }
    }
}

// MARK: - Toast by Maptransition

extension MapViewController {
    func showToastMessgeWithMap(with text: String) {
        switch self.mapTransition {
        case .tapBar:
            self.showToast(message: text, height: 170)
        case .push:
            self.showToast(message: text, height: 120)
        }
    }
}

fileprivate extension Coordinates {
    func convertNMLatLng() -> [NMGLatLng] {
        return self.map { coordinate in
            NMGLatLng(lat: coordinate[1], lng: coordinate[0])
        }
    }
    
    func calculateCenterPoint() -> (latitude: Double, longitude: Double) {
        var latitudes: [Double] = []
        var longitudes: [Double] = []
        
        let coordinates = self
        
        for coordinate in coordinates {
            latitudes.append(coordinate[1])
            longitudes.append(coordinate[0])
        }

        guard let minLatitude = latitudes.min(),
              let minlongitude = longitudes.min(),
              let maxLatitude = latitudes.max(),
              let maxlongitude = longitudes.max() else {
            return (latitude: 0.0, longitude: 0.0)
        }
        
        let centerLatitude = minLatitude + ((maxLatitude - minLatitude) / 2)
        let centerLongitude = minlongitude + ((maxlongitude - minlongitude) / 2)

        return (latitude: centerLatitude, longitude: centerLongitude)
    }
    
    func calculatePolygonSize() -> Double {
        var size = 0.0
        
        let coordinates = self

        for index in 0..<coordinates.count {
            let j = (index + 1) % self.count
            size += coordinates[index][1] * coordinates[j][0]
            size -= coordinates[j][1] * coordinates[index][0]
        }

        size /= 2.0
        size = abs(size)

        return size * 10000
    }
}

extension UIView {

    func asImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: self.bounds)
        return renderer.image { renderImageContext in
            self.layer.render(in: renderImageContext.cgContext)
        }
    }
        
}
