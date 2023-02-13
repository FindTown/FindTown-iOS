//
//  MyPageViewController.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/31.
//

import UIKit

import FindTownCore
import FindTownUI
import RxCocoa
import RxSwift

final class MyPageViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let viewModel: MyPageViewModel?
    private let dataSource = MyPageSections.dataSource
    
    // MARK: - Views
    
    private let indicator = UIActivityIndicatorView(style: .medium)
    
    lazy var collectionView = MyPageCollectionView()
    
    // MARK: - Life Cycle
    
    init(viewModel: MyPageViewModel) {
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
        view.addSubview(collectionView)
        view.addSubview(indicator)
    }
    
    override func setLayout() {
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.topAnchor.constraint(equalTo: view.topAnchor),
            indicator.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            indicator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            indicator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    override func setupView() {
        self.title = "마이"
        view.backgroundColor = FindTownColor.white.color
        
        indicator.startAnimating()
        
        collectionView.isHidden = true
        collectionView.backgroundColor = FindTownColor.white.color
        collectionView.dataSource = self
        
        viewModel?.fetchMemberInfo()
    }
    
    override func bindViewModel() {
        
        // Input
        
        viewModel?.input.fetchFinishTrigger
            .bind { [weak self] in
                self?.indicator.stopAnimating()
                self?.indicator.isHidden = true
                self?.collectionView.isHidden = false
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .bind { [weak self] indexPath in
                self?.viewModel?.navigateToPage(indexPath)
            }
            .disposed(by: disposeBag)
        
        // Output
        
        viewModel?.output.signoutNotice
            .subscribe { [weak self] _ in
                self?.showAlertSuccessCancelPopUp(title: "동네한입", message: "로그아웃 하시겠어요?",
                                                  successButtonText: "로그아웃", cancelButtonText: "취소",
                                                  successButtonAction: { })
            }
            .disposed(by: disposeBag)
        
        viewModel?.output.withDrawNotice
            .subscribe { [weak self] _ in
                self?.showAlertSuccessCancelPopUp(title: "회원탈퇴",
                                                  message: "탈퇴 시 모든 정보는 삭제됩니다.\n(단, 동네후기는 제외)\n정말로 탈퇴하시겠어요?",
                                                  successButtonText: "탈퇴", cancelButtonText: "취소",
                                                  successButtonAction: { })
            }
            .disposed(by: disposeBag)
        
        viewModel?.output.errorNotice
            .subscribe { [weak self] _ in
                self?.indicator.stopAnimating()
                self?.showErrorNoticeAlertPopUp(message: "네트워크 오류가 발생하였습니다.", buttonText: "확인")
            }
            .disposed(by: disposeBag)
    }
}

extension MyPageViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        switch self.dataSource[section] {
        case .topHeader(_):
            return 0
        case let .support(supports):
            return supports.count
        case let.info(infomations):
            return infomations.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch self.dataSource[indexPath.section] {
        case .topHeader(_):
            return UICollectionViewCell()
        case let .support(supports):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SupportSectionCollectionViewCell.reuseIdentifier, for: indexPath
            ) as? SupportSectionCollectionViewCell
            if let cell = cell {
                let item = supports[indexPath.item]
                cell.setupCell(model: item)
                return cell
            }
            return UICollectionViewCell()
        case let .info(infomations):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: InfoSectionCollectionViewCell.reuseIdentifier, for: indexPath
            ) as? InfoSectionCollectionViewCell
            if let cell = cell {
                let item = infomations[indexPath.item]
                cell.setupCell(model: item)
                return cell
            }
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let dividerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: DividerView.reuseIdentifier,
                for: indexPath
            ) as? DividerView
            if let dividerView = dividerView {
                return dividerView
            }
            return UICollectionReusableView()
        case UICollectionView.elementKindSectionFooter:
            let collectionHeaderView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: CollectionHeaderView.reuseIdentifier,
                for: indexPath
            ) as? CollectionHeaderView
            
            if let collectionHeaderView = collectionHeaderView {
                collectionHeaderView.bind(viewModel)
                return collectionHeaderView
            }
            return UICollectionReusableView()
        default:
            return UICollectionReusableView()
        }
    }
}
