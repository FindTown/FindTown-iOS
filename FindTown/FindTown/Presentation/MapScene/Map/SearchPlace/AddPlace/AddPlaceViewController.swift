//
//  AddPlaceViewController.swift
//  FindTown
//
//  Created by 장선영 on 2023/10/31.
//

import UIKit

import FindTownCore
import FindTownUI

import SnapKit
import RxSwift
import RxCocoa

enum PlaceStatus {
    case isRegistered
    case notRegistered
}

final class AddPlaceViewController: BaseViewController {
    
    private let doneButton = UIBarButtonItem(title: "완료", style: .done, target: nil, action: nil)
    
    private let placeInfoView = PlaceInfoView()
    private let selectReasonView = UIView()
    private let selectTitleLabel = FindTownLabel(text: "혼밥하기 좋은 이유는 무엇인가요?", font: .body1)
    private let selectTableView = SelectReasonTableView()
    private let writeReasonView = UIView()
    private let writeTitleLabel = FindTownLabel(text: "다른 이유가 있다면 작성해주세요.", font: .body1)
    private let writeTextView = FindTownTextView(
                                placeholder: "다른 사람에게 추천할만한 이유가 있다면 알려주세요.\n(최소 10자 이상 작성)",
                                maximumText: 100)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func bindViewModel() {
        
        doneButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                let nextVC = SuccesAddPlaceViewController()
                self?.navigationController?.pushViewController(nextVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        let mockData = BehaviorRelay<[String]>(value: ["test", "test", "test"])
        
        
        mockData
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: selectTableView.rx.items(
                cellIdentifier: SelectReasonTableViewCell.reuseIdentifier,
                cellType: SelectReasonTableViewCell.self)) {
                index, item, cell in
//                cell.setCell(data: item)
//                guard let searchText = self.searchText else { return }
//                cell.setSearchedTextColored(searchText, red.color)
            }.disposed(by: disposeBag)
    }
    
    override func setupView() {
        self.view.backgroundColor = .white
        self.hideKeyboard()
        self.title = "장소 등록"
        self.navigationItem.rightBarButtonItem = doneButton
//        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        self.stackView.layoutMargins = UIEdgeInsets(top: 24,
                                                    left: 16,
                                                    bottom: 38,
                                                    right: 16)
        
        self.stackView.isLayoutMarginsRelativeArrangement = true
        self.stackView.spacing = 40
    }
    
    override func addView() {
        super.addView()
        
        [placeInfoView, selectReasonView, writeReasonView].forEach {
            self.stackView.addArrangedSubview($0)
        }
        
        [selectTitleLabel, selectTableView].forEach {
            self.selectReasonView.addSubview($0)
        }
        
        [writeTitleLabel, writeTextView].forEach {
            self.writeReasonView.addSubview($0)
        }
    }
    
    override func setLayout() {
        super.setLayout()
        
        selectReasonView.snp.makeConstraints {
            $0.height.equalTo(168)
        }
        
        selectTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        selectTableView.snp.makeConstraints {
            $0.top.equalTo(selectTitleLabel.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        writeReasonView.snp.makeConstraints {
            $0.height.equalTo(224)
        }
        
        writeTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        writeTextView.snp.makeConstraints {
            $0.top.equalTo(writeTitleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
