//
//  SearchViewController.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/20.
//

import UIKit

import FindTownUI
import FindTownCore

import RxSwift
import RxCocoa
import SnapKit

final class SearchViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let viewModel: SearchViewModel?
    private let removeEveryLabelTapGesture = UITapGestureRecognizer()
    
    // MARK: - Views
    
    private let searchTextField = FindTownSearchTextField()
    private let searchedDataLabel = FindTownLabel(text: "최근 검색한 동네", font: .subtitle5)
    private let removeEveryButton = UIButton()
    private let searchedCollectionView = SearchedDongCollectionView()
    private let emptyDataLabel = FindTownLabel(text: "검색 내역이 없습니다.", font: .body4, textColor: .grey5)
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
        self.hideKeyboard()
        firstEnterCheck()
    }
    
    // MARK: - Functions
    
    override func addView() {
        [searchedDataLabel,
         removeEveryButton,
         emptyDataLabel,
         searchedCollectionView,
         selectJachiguTitle,
         countyCollectionView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        searchedDataLabel.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(54)
            $0.leading.equalToSuperview().inset(16)
        }
        
        removeEveryButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(searchedDataLabel)
        }
        
        emptyDataLabel.snp.makeConstraints {
            $0.top.equalTo(searchedDataLabel.snp.bottom).offset(24)
            $0.leading.equalTo(searchedDataLabel)
        }
        
        searchedCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchedDataLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(36)
        }
        
        NSLayoutConstraint.activate([
            selectJachiguTitle.topAnchor.constraint(equalTo: searchedDataLabel.bottomAnchor, constant: 127),
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
        searchTextField.placeholder = "동으로 검색해보세요."
        searchTextField.delegate = self
        self.navigationItem.titleView = searchTextField
        self.navigationItem.titleView?.widthAnchor.constraint(equalToConstant: 315).isActive = true
        
        removeEveryButton.setTitle("전체삭제", for: .normal)
        removeEveryButton.titleLabel?.font = FindTownFont.label1.font
        removeEveryButton.setTitleColor(FindTownColor.grey5.color, for: .normal)
    }
    
    override func bindViewModel() {
        
        // Input
        
        removeEveryButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.showAlertSuccessCancelPopUp(
                    title: "",
                    message: "최근 검색한 동네를\n모두 삭제할까요?",
                    successButtonText: "삭제",
                    cancelButtonText: "취소",
                    successButtonAction: { self?.viewModel?.input.allDeleteTrigger.onNext(()) }
                )
            })
            .disposed(by: disposeBag)
        
        countyCollectionView.rx.modelSelected(County.self)
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] country in
                self?.viewModel?.input.selectedCounty.onNext(country.rawValue)
            }
            .disposed(by: disposeBag)
        
        // Output
        
        viewModel?.output.searcedDataSource
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: searchedCollectionView.rx.items(
                cellIdentifier: SearchedDongCollectionViewCell.reuseIdentifier,
                cellType: SearchedDongCollectionViewCell.self)) {
                index, item, cell in
                    cell.delegate = self.viewModel
                    cell.setupCell(item)
            }.disposed(by: disposeBag)
        
        viewModel?.output.searcedDataSource
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                if data.isEmpty {
                    self?.searchedCollectionView.isHidden = true
                    self?.emptyDataLabel.isHidden = false
                } else {
                    self?.searchedCollectionView.isHidden = false
                    self?.emptyDataLabel.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        viewModel?.output.countyDataSource
            .observe(on: MainScheduler.instance)
            .bind(to: countyCollectionView.rx.items(
                cellIdentifier: CityCollectionViewCell.reuseIdentifier,
                cellType: CityCollectionViewCell.self)) { index, item, cell in
                    
                    cell.setupCell(itemText: item.rawValue)
                    
                }.disposed(by: disposeBag)
    }
    
    private func firstEnterCheck() {
        if !UserDefaultsSetting.isSearchFirstEnter {
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

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let searched = textField.text {
            self.viewModel?.input.addSearchedData.onNext(searched)
        }
        textField.resignFirstResponder()
        return true
    }
}
