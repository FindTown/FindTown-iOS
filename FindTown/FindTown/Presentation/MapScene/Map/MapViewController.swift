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
    
    var currentIndex: CGFloat = 0
    
    // MARK: Map property
    
    var villagePolygonOverlay: NMFPolygonOverlay?
    
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
        viewModel?.output.categoryDataSource.observe(on: MainScheduler.instance)
            .bind(to: categoryCollectionView.rx.items(cellIdentifier: MapCategoryCollectionViewCell.reuseIdentifier,
                                              cellType: MapCategoryCollectionViewCell.self)) { index, item, cell in
                cell.setupCell(image: item.image, title: item.description)
                if index == 0 {
                    self.selectFirstItem(item)
                }
            }.disposed(by: disposeBag)
        
        /// iconCollectionView 데이터 바인딩
        viewModel?.output.storeDataSource.observe(on: MainScheduler.instance)
            .bind(to: storeCollectionView.rx.items(cellIdentifier: MapStoreCollectionViewCell.reuseIdentifier,
                                              cellType: MapStoreCollectionViewCell.self)) { index, item, cell in
                cell.setupCell(store: item)
                cell.delegate = self
            }.disposed(by: disposeBag)
        
        /// 선택한 iconCell에 맞는 detailCategoryView 데이터 보여주게 함
        categoryCollectionView.rx.modelSelected(Category.self)
            .map { category in
                return category.detailCategories
            }
            .subscribe(onNext: { detailCategories in
                self.detailCategoryView.setStackView(data: detailCategories)
            })
            .disposed(by: disposeBag)
        
        viewModel?.output.city
            .subscribe(onNext: { [weak self] city in
                self?.addressButton.setTitle(city.description, for: .normal)
            })
            .disposed(by: disposeBag)
        
        viewModel?.output.cityBoundaryCoordinates
            .subscribe(onNext: { [weak self] boundaryCoordinates in
                self?.setVillageCooridnateOverlay(boundaryCoordinates)
            })
            .disposed(by: disposeBag)
            
        
        viewModel?.output.isFavoriteCity
            .bind(to: rx.isFavoriteCity)
            .disposed(by: disposeBag)
        
        viewModel?.output.errorNotice
            .subscribe { [weak self] _ in
                self?.showErrorNoticeAlertPopUp(message: "네트워크 오류가 발생하였습니다.", buttonText: "확인")
            }
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
        
        [categoryCollectionView, detailCategoryView, storeCollectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mapView.addSubview($0)
        }
    }
    
    override func setupView() {
        self.title = "동네 지도"
        view.backgroundColor = FindTownColor.back2.color
        
        naviBarSubView.backgroundColor = FindTownColor.white.color
        self.navigationItem.rightBarButtonItem = favoriteButton
        self.storeCollectionView.delegate = self
        favoriteButton.tintColor = FindTownColor.grey4.color
        
        self.viewModel?.setCity()
        setMapZoomLevel()
        setMapLayerGrounp()
    }

    override func setLayout() {
        setNaviBarLayout()
        setMapViewLayout()
    }
    
    private func selectFirstItem(_ item: MCategory) {
        DispatchQueue.main.async {
            self.categoryCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .bottom)
//            self.detailCategoryView.setStackView(data: item.detailCategories)
        }
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
            storeCollectionView.heightAnchor.constraint(equalToConstant: 142),
            storeCollectionView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor),
            storeCollectionView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor),
            storeCollectionView.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -32)
        ])
        
        NSLayoutConstraint.activate([
            detailCategoryView.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor, constant: 1.0),
            detailCategoryView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 16.0)
        ])
    }
}

// MARK: MapView

extension MapViewController {
    
    func setMapZoomLevel() {
        mapView.minZoomLevel = 10.0
                
        // 서울 인근 카메라 제한
        mapView.extent = NMGLatLngBounds(southWestLat: 37.40, southWestLng: 126.70, northEastLat: 37.60, northEastLng: 127.10)
    }
    
    func setMapLayerGrounp() {
        mapView.setLayerGroup(NMF_LAYER_GROUP_MOUNTAIN, isEnabled: true)
        mapView.setLayerGroup(NMF_LAYER_GROUP_TRANSIT, isEnabled: true)
    }
    
    func setVillageCooridnateOverlay(_ boundaryCoordinates: Coordinates) {
        villagePolygonOverlay?.mapView = nil
        
        let cameraPosition = NMFCameraPosition(NMGLatLng(lat: boundaryCoordinates[0][1], lng: boundaryCoordinates[0][0]), zoom: 14, tilt: 0, heading: 0)
        mapView.moveCamera(NMFCameraUpdate(position: cameraPosition))

        let villagePolygon = NMGPolygon(ring: NMGLineString(points: MapConstant.koreaBoundaryCoordinates.convertNMLatLng()), interiorRings: [NMGLineString(points: boundaryCoordinates.convertNMLatLng())])
        villagePolygonOverlay = NMFPolygonOverlay(villagePolygon as! NMGPolygon<AnyObject>)
        
        villagePolygonOverlay?.fillColor = UIColor(red: 26, green: 26, blue: 26).withAlphaComponent(0.2)
        villagePolygonOverlay?.mapView = mapView
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
            print(isSelect)
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
