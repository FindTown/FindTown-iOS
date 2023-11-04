//
//  SearchPlaceViewController.swift
//  FindTown
//
//  Created by 장선영 on 2023/10/31.
//

import UIKit

import FindTownCore

import SnapKit
import RxSwift
import RxCocoa

final class SearchPlaceViewController: BaseViewController {
    
    private let closeButton = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: nil, action: nil)
    
    let searchTextField = SearchTextField()
    let searchedTableView = SearchedPlaceTableView()
    let emptyDataView = EmptySearchedDataView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.leftBarButtonItem = closeButton
    }
    
    override func bindViewModel() {
        let mockData = BehaviorRelay<[String]>(value: ["test", "test", "test"])
        
        
        mockData
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: searchedTableView.rx.items(cellIdentifier: SearchedPlaceTableViewCell.reuseIdentifier,
                                         cellType: SearchedPlaceTableViewCell.self)) {
                index, item, cell in
//                cell.setCell(data: item)
//                guard let searchText = self.searchText else { return }
//                cell.setSearchedTextColored(searchText, red.color)
            }.disposed(by: disposeBag)
        
        searchedTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.pushViewController(AddPlaceViewController(), animated: true)
            })
            .disposed(by: disposeBag)
        
        closeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    override func setupView() {
        self.title = "추천 장소 검색"
        self.view.backgroundColor = .white
        searchTextField.placeholder = "장소 이름을 입력해주세요."
    }
    
    override func addView() {
        [searchTextField, emptyDataView, searchedTableView].forEach {
            self.view.addSubview($0)
        }
    }
    
    override func setLayout() {
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        searchTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(safeArea).inset(24)
        }
        
        searchedTableView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(17)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        emptyDataView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(17)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
