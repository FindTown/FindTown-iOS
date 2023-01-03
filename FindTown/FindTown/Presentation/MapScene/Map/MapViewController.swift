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

class MapViewController: BaseViewController {
    
    let mapView = NMFMapView()
    
    let naviBarSubView = UIView()
    let addressButton = UIButton()
    let mapToggle = MapSegmentControl(items: ["인프라", "테마"])

    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 8
        flowLayout.sectionInset = UIEdgeInsets(top: 0.0, left: 17.0, bottom: 0.0, right: 82.0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        collectionView.register(MapCollectionViewCell.self,
                                forCellWithReuseIdentifier: MapCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    let detailCategoryView = MapDetailCategoryView()
        
    /// collectionView의 데이터 (아이콘 이미지 네임, 카테고리) 로 구성
    var collectionViewDataSource: [(String, String)] = [("martIcon" ,"마트&편의점"),
                                                        ("cafeIcon","카페"),
                                                        ("bellIcon","치안"),
                                                        ("storeIcon","생활"),
                                                        ("healthIcon","운동"),
                                                        ("walkIcon","산책"),
                                                        ("hospitalIcon","병원"),
                                                        ("pharmacyIcon","약국")]
    
    var collectionViewData: [Category] = []

    var viewModel: MapViewModel?
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        returnTestData()
        collectionView.reloadData()
        detailCategoryView.isHidden = true
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
        
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "favoriteBtn"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(didTapRightBarButton))
        self.navigationItem.rightBarButtonItem = rightBarButton
        setUpAddressButton()
    }

    override func setLayout() {
        
        let view = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: naviBarSubView.bottomAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
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

private extension MapViewController {
    
    @objc func didTapRightBarButton() {
        print("didTapRightBarButton")
    }
    
    @objc func didTapAddressButton() {
        print("didTapAddressButton")
        
        let addressPopupVC = AddressPopUpViewController()
        addressPopupVC.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(addressPopupVC, animated: true)
    }
}

private extension MapViewController {
    
    func setUpAddressButton() {
        addressButton.setTitle("00시 00구 00동", for: .normal)
        addressButton.setTitleColor(FindTownColor.grey7.color, for: .normal)
        addressButton.titleLabel?.font = FindTownFont.label1.font
        addressButton.setImage(UIImage(named: "dropDown"), for: .normal)
        addressButton.semanticContentAttribute = .forceRightToLeft
        addressButton.addTarget(self, action: #selector(didTapAddressButton), for: .touchUpInside)
    }
    
    func setStackView(data: [DetailCategory]) {
        detailCategoryView.detailCategoryStackView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        for i in 0..<data.count{
            let view = MapDetailComponentView()
            view.textLabel.text = data[i].detailTitle
            view.colorView.backgroundColor = data[i].color
            detailCategoryView.detailCategoryStackView.addArrangedSubview(view)
         }
     }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource

extension MapViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return collectionViewDataSource.count
        return collectionViewData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapCollectionViewCell.reuseIdentifier, for: indexPath) as? MapCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let cellData = collectionViewData[indexPath.item]
        cell.setupCell(image: cellData.image, title: cellData.title)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailCategories = collectionViewData[indexPath.item].detailCategories
        detailCategoryView.isHidden = false
        setStackView(data: detailCategories)
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension MapViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionViewData[indexPath.item].title.size(withAttributes: [NSAttributedString.Key.font : FindTownFont.body4.font]).width + 45, height: 32)
    }
}


extension MapViewController {
    func returnTestData() {
        let detailCategories1 = [DetailCategory(color: UIColor.init(red: 255,
                                                                   green: 30,
                                                                   blue: 30),
                                               detailTitle: "편의점"),
                                DetailCategory(color: UIColor.init(red: 255,
                                                                   green: 210,
                                                                   blue: 49),
                                               detailTitle: "편의점편의점편의점"),
                                DetailCategory(color: UIColor.init(red: 255,
                                                                   green: 30,
                                                                   blue: 30),
                                               detailTitle: "편의점")]
        
        let detailCategories2 = [DetailCategory(color: UIColor.init(red: 255,
                                                                   green: 30,
                                                                   blue: 30),
                                               detailTitle: "편의점"),
                                DetailCategory(color: UIColor.init(red: 255,
                                                                   green: 210,
                                                                   blue: 49),
                                               detailTitle: "편의점"),
                                DetailCategory(color: UIColor.init(red: 255,
                                                                   green: 30,
                                                                   blue: 30),
                                               detailTitle: "편의점")]
        
    
        let categories = [Category(image: UIImage(named: "martIcon")?.withRenderingMode(.alwaysTemplate) ?? UIImage(),
                                   title: "마트&편의점",
                                   detailCategories: detailCategories1),
                          Category(image: UIImage(named: "cafeIcon")?.withRenderingMode(.alwaysTemplate) ?? UIImage(),
                                   title: "카페",
                                   detailCategories: detailCategories2),
                          Category(image: UIImage(named: "bellIcon")?.withRenderingMode(.alwaysTemplate) ?? UIImage(),
                                   title: "치안",
                                   detailCategories: detailCategories1)]
                          
        self.collectionViewData = categories
    }
}
