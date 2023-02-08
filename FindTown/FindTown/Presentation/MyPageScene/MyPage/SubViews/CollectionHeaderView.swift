//
//  CollectionHeaderView.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/31.
//

import UIKit

import FindTownCore
import FindTownUI
import RxSwift
import RxCocoa

// 마이페이지 최상단 뷰
final class CollectionHeaderView: UICollectionReusableView {
    
    // MARK: - Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    private let disposeBag = DisposeBag()
    var viewModel: MyPageViewModel?
    
    // MARK: - Views
    
    private let nickName = FindTownLabel(text: "", font: .subtitle2)
    
    private let nickNameChangeButton = FTButton(style: .mediumTintedWithOpacity)
    
    private let villagePeriod = FindTownLabel(text: "", font: .label1, textColor: .grey6)
    
    private let reviewButton = FTButton(style: .largeTinted)
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addView()
        setLayout()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func addView() {
        [nickName, nickNameChangeButton, villagePeriod, reviewButton].forEach {
            addSubview($0)
        }
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            nickName.topAnchor.constraint(equalTo: super.topAnchor, constant: 24),
            nickName.leadingAnchor.constraint(equalTo: super.leadingAnchor, constant: 16),
        ])
        
        NSLayoutConstraint.activate([
            nickNameChangeButton.topAnchor.constraint(equalTo: super.topAnchor, constant: 24),
            nickNameChangeButton.trailingAnchor.constraint(equalTo: super.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            villagePeriod.topAnchor.constraint(equalTo: nickName.bottomAnchor, constant: 4),
            villagePeriod.leadingAnchor.constraint(equalTo: super.leadingAnchor, constant: 16),
        ])
        
        NSLayoutConstraint.activate([
            reviewButton.topAnchor.constraint(equalTo: villagePeriod.bottomAnchor, constant: 32),
            reviewButton.leadingAnchor.constraint(equalTo: super.leadingAnchor, constant: 16),
            reviewButton.trailingAnchor.constraint(equalTo: super.trailingAnchor, constant: -16),
        ])
    }
    
    private func setupView() {
        nickNameChangeButton.setTitle("닉네임 수정", for: .normal)
        nickNameChangeButton.configuration?.contentInsets.leading = 8
        nickNameChangeButton.configuration?.contentInsets.trailing = 8
        nickNameChangeButton.setTitleColor(FindTownColor.grey5.color, for: .normal)
        nickNameChangeButton.configuration?.baseBackgroundColor = FindTownColor.grey4.color
        
        reviewButton.changesSelectionAsPrimaryAction = false
        reviewButton.isSelected = true
        reviewButton.setTitle("내가 쓴 동네 후기", for: .normal)
    }
    
    func bindViewModel() {
        nickNameChangeButton.rx.tap
            .bind { [weak self] in
                self?.viewModel?.input.changeNicknameButtonTrigger.onNext(())
            }
            .disposed(by: disposeBag)
        
        reviewButton.rx.tap
            .bind { [weak self] in
                self?.viewModel?.input.reviewButtonTrigger.onNext(())
            }
            .disposed(by: disposeBag)
        
        viewModel?.output.myNickname
            .asDriver(onErrorJustReturn: "")
            .drive { [weak self] in
                self?.nickName.text = $0
            }
            .disposed(by: disposeBag)
        
        viewModel?.output.myVillagePeriod
            .asDriver(onErrorJustReturn: "")
            .drive { [weak self] in
                self?.villagePeriod.text = $0
            }
            .disposed(by: disposeBag)
    }
}
