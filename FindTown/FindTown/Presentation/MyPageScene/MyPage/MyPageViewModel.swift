//
//  MyPageViewModel.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/31.
//

import UIKit

import FindTownCore
import RxSwift
import RxRelay

protocol MyPageViewModelDelegate {
    func goToChangeNickname()
    func goToMyTownReview()
}

protocol MyPageViewModelType {
    func goToChangeNickname()
    func goToMyTownReview()
}

final class MyPageViewModel: BaseViewModel {
    
    struct Input {
        let changeNicknameButtonTrigger = PublishSubject<Void>()
        let reviewButtonTrigger = PublishSubject<Void>()
    }
    
    struct Output {
        
    }
    
    let input = Input()
    let output = Output()
    let delegate: MyPageViewModelDelegate
    
    init(
        delegate: MyPageViewModelDelegate
    ) {
        self.delegate = delegate
    
        super.init()
        self.bind()
    }
    
    func bind() {
        self.input.changeNicknameButtonTrigger
            .bind { [weak self] in
                self?.goToChangeNickname()
            }
            .disposed(by: disposeBag)
        
        self.input.reviewButtonTrigger
            .bind {[weak self] in
                self?.goToMyTownReview()
            }
            .disposed(by: disposeBag)
    }
}

extension MyPageViewModel: MyPageViewModelType {
    func goToChangeNickname() {
        delegate.goToChangeNickname()
    }
    
    func goToMyTownReview() {
        delegate.goToMyTownReview()
    }
}

enum MyPageDemoData {
    static let dataSource = [
        MyPageSection.topHeader([ ]),
        MyPageSection.support(
            [
                .init(image: UIImage(),
                      title: "지원",
                      action: { print("") }),
                .init(image: UIImage(named: "contact") ?? UIImage(),
                      title: "문의하기",
                      action: { print("문의하기") }),
                .init(image: UIImage(named: "suggestion") ?? UIImage(),
                      title: "제안하기",
                      action: { print("제안하기") }),
            ]
        ),
        MyPageSection.info(
            [
                .init(title: "정보",
                      index: 0,
                      action: { print("정보") }),
                .init(title: "이용약관",
                      index: 1,
                      action: { print("이용약관") }),
                .init(title: "개인정보처리 방침",
                      index: 2,
                      action: { print("개인정보처리 방침") }),
                .init(title: "앱 버전",
                      index: 3,
                      action: { print("앱 버전") }),
                .init(title: "로그아웃",
                      index: 4,
                      action: { print("로그아웃") }),
                .init(title: "회원탈퇴",
                      index: 5,
                      action: { print("회원탈퇴") }),
            ]
        ),
    ]
}

enum MyPageSection {
    struct TopHeader { }
    
    struct Support {
        let image: UIImage
        let title: String
        let action: (() -> ())
    }
    
    struct Info {
        let title: String
        let index: Int
        let action: (() -> ())
    }
    
    case topHeader([TopHeader])
    case support([Support])
    case info([Info])
}
