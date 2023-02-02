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
    private let dataSource = MyPageDemoData.dataSource
    
    // MARK: - Views

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
    }
    
    override func setLayout() {
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
        
        collectionView.backgroundColor = FindTownColor.white.color
        collectionView.dataSource = self
    }
    
    override func bindViewModel() {
        
    }
}

extension MyPageViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.dataSource[section] {
        case .topHeader(_):
            return 0
        case let .support(supports):
            return supports.count
        case let.info(infomations):
            return infomations.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch self.dataSource[indexPath.section] {
        case .topHeader(_):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SupprotSectionCollectionViewCell.reuseIdentifier, for: indexPath
            ) as! SupprotSectionCollectionViewCell
            return cell
        case let .support(supports):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SupprotSectionCollectionViewCell.reuseIdentifier, for: indexPath
            ) as! SupprotSectionCollectionViewCell
            let item = supports[indexPath.item]
            cell.setupCell(model: item)
            cell.viewModel = viewModel
            return cell
        case let .info(infomations):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: InfoSectionCollectionViewCell.reuseIdentifier, for: indexPath
            ) as! InfoSectionCollectionViewCell
            let item = infomations[indexPath.item]
            cell.setupCell(model: item)
            cell.viewModel = viewModel
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let dividerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: DividerView.reuseIdentifier,
                for: indexPath
            ) as! DividerView
            return dividerView
        case UICollectionView.elementKindSectionFooter:
            let collectionHeaderView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: CollectionHeaderView.reuseIdentifier,
                for: indexPath
            ) as! CollectionHeaderView
            collectionHeaderView.viewModel = viewModel
            return collectionHeaderView
        default:
            return UICollectionReusableView()
        }
    }
}
