//
//  AddressSheetViewController.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/08.
//

import UIKit
import FindTownCore
import FindTownUI
import RxSwift

final class AddressSheetViewController: BaseBottomSheetViewController {
    
    var viewModel: AddressSheetViewModel?
    
    private let titleLabel = FindTownLabel(
                                text: "다른 동네 보기",
                                font: .subtitle4,
                                textColor: .black)
    
    fileprivate let backButton = ImageButton(imageText: "navi.back", tintColor: .grey7)
    fileprivate let countyCollectionView = CityCollectionView()
    fileprivate let villageCollectionView = CityCollectionView()
    fileprivate let completeButton = FTButton(style: .largeFilled)
    
    private let screenWidth = UIScreen.main.bounds.width
    
    init(viewModel: AddressSheetViewModel) {
        super.init(bottomHeight: screenWidth * 1.3)
        self.viewModel = viewModel
     }
    
    override init(bottomHeight: CGFloat) {
        super.init(bottomHeight: bottomHeight)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func setupView() {
        super.setupView()
        
        completeButton.setTitle("선택 완료", for: .normal)
        self.rx.cityType.onNext(.county)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        completeButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                if self?.completeButton.isSelected == false {
                    self?.viewModel?.input.didTapCompleteButton.onNext(())
                }
            }
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.rx.cityType.onNext(.county)
            }
            .disposed(by: disposeBag)
        
        viewModel?.output.countyDataSource
            .bind(to: countyCollectionView.rx.items(cellIdentifier: CityCollectionViewCell.reuseIdentifier,
                                              cellType: CityCollectionViewCell.self)) { index, item, cell in
                cell.setupCell(itemText: item.rawValue)
            }.disposed(by: disposeBag)
        
        viewModel?.output.villageDataSource
            .bind(to: villageCollectionView.rx.items(cellIdentifier: CityCollectionViewCell.reuseIdentifier,
                                              cellType: CityCollectionViewCell.self)) { index, item, cell in
                cell.setupCell(itemText: item.village)
            }.disposed(by: disposeBag)
        
        countyCollectionView.rx.modelSelected(County.self)
            .map { county in
                return county.villages.map { City(county: county, village: $0) }
            }
            .subscribe(onNext: { cities in
                self.viewModel?.output.villageDataSource.onNext(cities)
                self.rx.cityType.onNext(.village)
            })
            .disposed(by: disposeBag)
        
        villageCollectionView.rx.modelSelected(City.self)
            .subscribe(onNext: { city in
                self.rx.completeButtonEnabled.onNext(true)
                self.viewModel?.input.selectedCity.onNext(city)
            })
            .disposed(by: disposeBag)
    }
    
    override func addView() {
        super.addView()
        
        [titleLabel,
         backButton,
         countyCollectionView,
         villageCollectionView,
         completeButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            bottomSheetView.addSubview($0)
        }
    }
    
    override func setLayout() {
        super.setLayout()
    
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.bottomSheetView.topAnchor, constant: 42),
            titleLabel.centerXAnchor.constraint(equalTo: self.bottomSheetView.centerXAnchor),
            
            backButton.leadingAnchor.constraint(equalTo: self.bottomSheetView.leadingAnchor, constant: 17),
            backButton.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor),
            
            countyCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25.0),
            countyCollectionView.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 17.0),
            countyCollectionView.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor, constant: -17.0),
            countyCollectionView.bottomAnchor.constraint(equalTo: completeButton.topAnchor, constant: -48.0),
            
            villageCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32.0),
            villageCollectionView.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 17.0),
            villageCollectionView.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor, constant: -17.0),
            villageCollectionView.bottomAnchor.constraint(equalTo: completeButton.topAnchor, constant: screenWidth * -0.128),
            
            completeButton.heightAnchor.constraint(equalToConstant: 48),
            completeButton.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 17.0),
            completeButton.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor, constant: -17.0),
            completeButton.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor),
            completeButton.bottomAnchor.constraint(equalTo: bottomSheetView.bottomAnchor, constant: -34.0)
        ])
    }
}

extension Reactive where Base: AddressSheetViewController {
    
    var cityType: Binder<CityType> {
        return Binder(self.base) { (viewController, cityType) in
            switch cityType {
            case .county:
                viewController.villageCollectionView.isHidden = true
                viewController.countyCollectionView.isHidden = false
                viewController.backButton.isHidden = true
                self.completeButtonEnabled.onNext(false)
            case .village:
                viewController.villageCollectionView.isHidden = false
                viewController.countyCollectionView.isHidden = true
                viewController.backButton.isHidden = false
            }
        }
    }
    
    var completeButtonEnabled: Binder<Bool> {
        return Binder(self.base) { (viewController, isEnabled) in
            if isEnabled == true {
                viewController.completeButton.isSelected = true
            } else {
                viewController.completeButton.isSelected = false
            }
        }
    }
}
