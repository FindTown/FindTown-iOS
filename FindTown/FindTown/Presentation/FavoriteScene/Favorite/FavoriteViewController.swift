//
//  Favorite1ViewController.swift
//  FindTown
//
//  Created by 장선영 on 2023/01/18.
//

import UIKit
import FindTownCore
import FindTownUI
import RxSwift

final class FavoriteViewController: BaseViewController {
    
    // MARK: - Properties
    
    var viewModel: FavoriteViewModel?
    
    // MARK: - Views
    
    fileprivate let anonymousView = AnonymousView()
    fileprivate let isEmptyView = EmptyView()
    fileprivate let favoriteTableView = FavoriteTableView()

    // MARK: - Life Cycle
    
    init(viewModel: FavoriteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    override func setupView() {
        self.title = "찜"
        self.view.backgroundColor = FindTownColor.back2.color
    }
    
    override func addView() {
        super.addView()
        
        [anonymousView, isEmptyView, favoriteTableView].forEach {
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let view = self.view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            anonymousView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            anonymousView.topAnchor.constraint(equalTo: view.topAnchor),
            anonymousView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            anonymousView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            isEmptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            isEmptyView.topAnchor.constraint(equalTo: view.topAnchor),
            isEmptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            isEmptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            favoriteTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favoriteTableView.topAnchor.constraint(equalTo: view.topAnchor),
            favoriteTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            favoriteTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    override func bindViewModel() {
        
        // MARK: ViewModel - Input
        
        self.anonymousView.signUpButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                self?.viewModel?.input.signUpButtonTrigger.onNext(())
            }
            .disposed(by: disposeBag)
        
        self.isEmptyView.findOutButton.rx.tap
            .bind { [weak self] in
                /// 홈 탭으로 이동
                self?.tabBarController?.selectedIndex = 0
            }
            .disposed(by: disposeBag)
        
        // MARK: ViewModel - Output
        
        self.viewModel?.output.viewStatus
            .bind(to: self.rx.favoriteViewStatus)
            .disposed(by: disposeBag)
        
        self.viewModel?.output.favoriteDataSource
            .observe(on: MainScheduler.instance)
            .filter { !$0.isEmpty }
            .bind(to: favoriteTableView.rx.items(cellIdentifier: TownTableViewCell.reuseIdentifier,
                                                 cellType: TownTableViewCell.self)) {
                index, item, cell in
                cell.setupCell(item)
                cell.introduceBtnAction = { [unowned self] in
                    self.viewModel?.input.townIntroButtonTrigger.onNext(())
                }
                cell.heartBtnAction = { [unowned self] in
                    self.showToast(message: "찜 목록에서 삭제되었어요")
                }
            }
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: FavoriteViewController {
    
    /// favoriteViewStatus에 따라 view 변경
    var favoriteViewStatus:Binder<FavoriteViewStatus> {
        return Binder(self.base) { viewcontroller, staus in
            switch staus {
            case .anonymous:
                viewcontroller.anonymousView.isHidden = false
                viewcontroller.isEmptyView.isHidden = true
                viewcontroller.favoriteTableView.isHidden = true
            case .isEmpty:
                viewcontroller.isEmptyView.isHidden = false
                viewcontroller.anonymousView.isHidden = true
                viewcontroller.favoriteTableView.isHidden = true
            case .isPresent:
                viewcontroller.favoriteTableView.isHidden = false
                viewcontroller.anonymousView.isHidden = true
                viewcontroller.isEmptyView.isHidden = true
            }
        }
    }
}
