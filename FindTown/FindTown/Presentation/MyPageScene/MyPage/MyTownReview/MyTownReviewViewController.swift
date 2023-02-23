//
//  MyTownReviewViewController.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/01.
//

import UIKit

import FindTownCore
import FindTownUI

final class MyTownReviewViewController: BaseViewController, UIScrollViewDelegate {
    
    // MARK: - Properties
    
    let viewModel: MyTownReviewViewModel?
    
    // MARK: - Views
    
    private let reviewTableView = ReviewTableView()
    
    // MARK: - Life Cycle
    
    init(viewModel: MyTownReviewViewModel) {
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
        view.addSubview(reviewTableView)
    }
    
    override func setLayout() {
        NSLayoutConstraint.activate([
            reviewTableView.topAnchor.constraint(equalTo: view.topAnchor),
            reviewTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            reviewTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            reviewTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    override func setupView() {
        self.title = "내가 쓴 동네 후기"
        view.backgroundColor = FindTownColor.back1.color
        reviewTableView.backgroundColor = FindTownColor.back1.color
        
        reviewTableView.rowHeight = UITableView.automaticDimension
        reviewTableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    override func bindViewModel() {
        
        viewModel?.output.reviewTableDataSource
            .asDriver(onErrorJustReturn: [])
            .drive(reviewTableView.rx.items(
                cellIdentifier: ReviewTableViewCell.reuseIdentifier,
                cellType: ReviewTableViewCell.self)) { index, item, cell in
                    
                    cell.setupCell(item)
                    
                }.disposed(by: disposeBag)
        
        viewModel?.output.errorNotice
            .subscribe { [weak self] _ in
                self?.showErrorNoticeAlertPopUp(message: "네트워크 오류가 발생하였습니다.",
                                                buttonText: "확인",
                                                buttonAction: {
                    self?.dismiss(animated: false) {
                        self?.navigationController?.popViewController(animated: true)
                    }})
            }
            .disposed(by: disposeBag)
    }
}
