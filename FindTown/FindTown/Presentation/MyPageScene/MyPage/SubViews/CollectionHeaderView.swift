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
    
    private let nickName = FindTownLabel(text: "닉네임", font: .subtitle2)
    
    private let nickNameChangeButton = FTButton(style: .mediumTintedWithOpacity)
    
    private let dongPeriod = FindTownLabel(text: "신림동 거주, 2년 6개월", font: .label1, textColor: .grey6)
    
    private let reviewButton = FTButton(style: .largeTinted)
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addView()
        setLayout()
        setupView()
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func addView() {
        [nickName, nickNameChangeButton, dongPeriod, reviewButton].forEach {
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
            dongPeriod.topAnchor.constraint(equalTo: nickName.bottomAnchor, constant: 4),
            dongPeriod.leadingAnchor.constraint(equalTo: super.leadingAnchor, constant: 16),
        ])
        
        NSLayoutConstraint.activate([
            reviewButton.topAnchor.constraint(equalTo: dongPeriod.bottomAnchor, constant: 32),
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
    
    private func bindViewModel() {
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
    }
}
