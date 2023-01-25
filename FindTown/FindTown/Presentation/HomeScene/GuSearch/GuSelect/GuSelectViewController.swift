//
//  SearchViewController.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/20.
//

import UIKit

import RxSwift
import RxCocoa
import FindTownUI
import FindTownCore

final class GuSelectViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let viewModel: GuSelectViewModel?
    private let allRemoveLabelTapGesture = UITapGestureRecognizer()
    
    // MARK: - Views
    
    private let recentlySearchTitle = FindTownLabel(text: "최근 검색한 동네", font: .subtitle5)
    fileprivate let allRemoveTitle = FindTownLabel(text: "전체삭제", font: .label1, textColor: .grey5)
    private let recentlySearchTitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    fileprivate let notSearchRecentlyTitle = FindTownLabel(text: "검색 내역이 없습니다.", font: .body4, textColor: .grey5)
    
    fileprivate let recentlyGuCollectionView = RecentlyGuCollectionView()
    
    private let selectJachiguTitle = FindTownLabel(text: "자치구를 선택해주세요.", font: .subtitle5)
    
    private let countyCollectionView = CityCollectionView()
    
    // MARK: - Life Cycle
    
    init(viewModel: GuSelectViewModel?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Functions
    
    override func addView() {
        
        [recentlySearchTitle, allRemoveTitle].forEach {
            recentlySearchTitleStackView.addArrangedSubview($0)
        }
        
        [recentlySearchTitleStackView, notSearchRecentlyTitle, recentlyGuCollectionView, selectJachiguTitle, countyCollectionView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        
        NSLayoutConstraint.activate([
            recentlySearchTitleStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            recentlySearchTitleStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            recentlySearchTitleStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            notSearchRecentlyTitle.topAnchor.constraint(equalTo: recentlySearchTitle.bottomAnchor, constant: 24),
            notSearchRecentlyTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
        
        recentlyGuCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recentlyGuCollectionView.topAnchor.constraint(equalTo: recentlySearchTitleStackView.bottomAnchor, constant: 20),
            recentlyGuCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            recentlyGuCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            recentlyGuCollectionView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            selectJachiguTitle.topAnchor.constraint(equalTo: recentlyGuCollectionView.bottomAnchor, constant: 72),
            selectJachiguTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
        
        countyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            countyCollectionView.topAnchor.constraint(equalTo: selectJachiguTitle.bottomAnchor, constant: 24),
            countyCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            countyCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            countyCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func setupView() {
        view.backgroundColor = FindTownColor.white.color
        
        allRemoveTitle.addGestureRecognizer(allRemoveLabelTapGesture)
        allRemoveTitle.isUserInteractionEnabled = true
    }
    
    override func bindViewModel() {
        
        recentlyGuCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        // Input
        
        allRemoveLabelTapGesture.rx.event
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.showAlertSuccessCancelPopUp(
                    title: "최근 검색한 동네를\n모두 삭제할까요?",
                    successTitle: "삭제",
                    cancelTitle: "취소",
                    buttonAction: { self?.viewModel?.input.allDeleteTrigger.onNext(()) }
                )
            }
            .disposed(by: disposeBag)
        
        countyCollectionView.rx.modelSelected(County.self)
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] country in
                self?.viewModel?.input.selectedCounty.onNext(country.rawValue)
            }
            .disposed(by: disposeBag)
        
        recentlyGuCollectionView.rx.modelSelected(String.self)
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] country in
                self?.viewModel?.input.selectedCounty.onNext(country)
            }
            .disposed(by: disposeBag)
        
        // Output
        
        viewModel?.output.searchFilterDataSource
            .observe(on: MainScheduler.instance)
            .bind(to: recentlyGuCollectionView.rx.items(
                cellIdentifier: RecentlyGuCollectionViewCell.reuseIdentifier,
                cellType: RecentlyGuCollectionViewCell.self)) { index, item, cell in
                    
                    cell.setupCell(item, index)
                    cell.delegate = self
                    
                }.disposed(by: disposeBag)
        
        viewModel?.output.countyDataSource
            .observe(on: MainScheduler.instance)
            .bind(to: countyCollectionView.rx.items(
                cellIdentifier: CityCollectionViewCell.reuseIdentifier,
                cellType: CityCollectionViewCell.self)) { index, item, cell in
                    
                    cell.setupCell(itemText: item.rawValue)
                    
                }.disposed(by: disposeBag)
        
        viewModel?.output.searchFilterDataSource
            .asDriver(onErrorJustReturn: [])
            .drive(self.rx.searchFilterStatus)
            .disposed(by: disposeBag)
    }
}

extension GuSelectViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath)
    -> CGSize {
        let filter = viewModel?.output.searchFilterDataSource.value[indexPath.row]
        return CGSize(width: (filter?.size(
            withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]
        ).width ?? 0) + 50, height: 40)
    }
}

extension GuSelectViewController: RecentlyGuCollectionViewCellDelegate {
    func closeTapped(filter: String) {
        self.viewModel?.input.removedCounty.onNext(filter)
    }
}

extension Reactive where Base: GuSelectViewController {
    
    var searchFilterStatus:Binder<[String]> {
        return Binder(self.base) { viewcontroller, guValues in
            if guValues.count == 0 {
                viewcontroller.notSearchRecentlyTitle.isHidden = false
                viewcontroller.allRemoveTitle.isHidden = true
                viewcontroller.recentlyGuCollectionView.isHidden = true
            } else {
                viewcontroller.notSearchRecentlyTitle.isHidden = true
                viewcontroller.allRemoveTitle.isHidden = false
                viewcontroller.recentlyGuCollectionView.isHidden = false
            }
        }
    }
}
