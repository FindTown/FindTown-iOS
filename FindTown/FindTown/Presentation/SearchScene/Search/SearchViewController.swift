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

final class SearchViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let viewModel: SearchViewModel?
    private let removeEveryLabelTapGesture = UITapGestureRecognizer()
    
    // MARK: - Views
    
    private let selectJachiguTitle = FindTownLabel(text: "자치구를 선택해주세요.", font: .subtitle5)
    
    private let countyCollectionView = CityCollectionView()
    
    // MARK: - Life Cycle
    
    init(viewModel: SearchViewModel?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstEnterCheck()
    }
    
    // MARK: - Functions
    
    override func addView() {
        [selectJachiguTitle, countyCollectionView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        NSLayoutConstraint.activate([
            selectJachiguTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
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
    }
    
    override func bindViewModel() {
        
        // Input
        
        removeEveryLabelTapGesture.rx.event
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.showAlertSuccessCancelPopUp(
                    title: "최근 검색한 동네를\n모두 삭제할까요?",
                    successButtonText: "삭제",
                    cancelButtonText: "취소",
                    successButtonAction: { self?.viewModel?.input.allDeleteTrigger.onNext(()) }
                )
            }
            .disposed(by: disposeBag)
        
        countyCollectionView.rx.modelSelected(County.self)
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] country in
                self?.viewModel?.input.selectedCounty.onNext(country.rawValue)
            }
            .disposed(by: disposeBag)
        
        // Output
        
        viewModel?.output.countyDataSource
            .observe(on: MainScheduler.instance)
            .bind(to: countyCollectionView.rx.items(
                cellIdentifier: CityCollectionViewCell.reuseIdentifier,
                cellType: CityCollectionViewCell.self)) { index, item, cell in
                    
                    cell.setupCell(itemText: item.rawValue)
                    
                }.disposed(by: disposeBag)
    }
    
    private func firstEnterCheck() {
        if !UserDefaults.standard.bool(forKey: "SearchFirstEnter") {
            viewModel?.input.serviceMapPopUpTrigger.onNext(())
        }
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
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
