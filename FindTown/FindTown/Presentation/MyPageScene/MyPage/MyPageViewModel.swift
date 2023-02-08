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
    func goToLogin()
    func goToChangeNickname()
    func goToMyTownReview()
    func goToInquiry()
    func goToPropose()
    func goToTerms()
    func goToPersonalInfo()
    func popUpSignout()
    func popUpWithDraw()
}

protocol MyPageViewModelType {
    func goToChangeNickname()
    func goToMyTownReview()
    func goToInquiry()
    func goToPropose()
    func goToTerms()
    func goToPersonalInfo()
    func popUpSignout()
    func popUpWithDraw()
}

final class MyPageViewModel: BaseViewModel {
    
    struct Input {
        let nickname = PublishSubject<String>()
        let villagePeriod = PublishSubject<String>()
        let fetchFinishTrigger = PublishSubject<Void>()
        let changeNicknameButtonTrigger = PublishSubject<Void>()
        let reviewButtonTrigger = PublishSubject<Void>()
        let inquiryTapTrigger = PublishSubject<Void>()
        let proposeTapTrigger = PublishSubject<Void>()
        let termsTapTrigger = PublishSubject<Void>()
        let personalInfoTapTrigger = PublishSubject<Void>()
        let signoutTapTrigger = PublishSubject<Void>()
        let withDrawTapTrigger = PublishSubject<Void>()
    }
    
    struct Output {
        let myNickname = PublishRelay<String>()
        let myVillagePeriod = PublishRelay<String>()
    }
    
    let input = Input()
    let output = Output()
    let delegate: MyPageViewModelDelegate
    
    // MARK: - UseCase
    
    let memberUseCase: MemberUseCase
    
    // MARK: - Task
    
    private var myInfoTask: Task<Void, Error>?
    
    init(
        delegate: MyPageViewModelDelegate,
        memberUseCase: MemberUseCase
    ) {
        self.delegate = delegate
        self.memberUseCase = memberUseCase
        
        super.init()
        self.bind()
    }
    
    func bind() {
        self.input.nickname
            .bind { [weak self] in
                self?.output.myNickname.accept($0)
            }
            .disposed(by: disposeBag)
        
        self.input.villagePeriod
            .bind { [weak self] in
                self?.output.myVillagePeriod.accept($0)
            }
            .disposed(by: disposeBag)
        
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
        
        self.input.inquiryTapTrigger
            .bind {[weak self] in
                self?.goToInquiry()
            }
            .disposed(by: disposeBag)
        
        self.input.proposeTapTrigger
            .bind {[weak self] in
                self?.goToPropose()
            }
            .disposed(by: disposeBag)
        
        self.input.termsTapTrigger
            .bind {[weak self] in
                self?.goToTerms()
            }
            .disposed(by: disposeBag)
        
        self.input.personalInfoTapTrigger
            .bind {[weak self] in
                self?.goToPersonalInfo()
            }
            .disposed(by: disposeBag)
        
        self.input.signoutTapTrigger
            .bind {[weak self] in
                self?.popUpSignout()
            }
            .disposed(by: disposeBag)
        
        self.input.withDrawTapTrigger
            .bind {[weak self] in
                self?.popUpWithDraw()
            }
            .disposed(by: disposeBag)
    }
    
    func navigateToPage(_ indexPath: IndexPath) {
        let sectionIndex = indexPath[0]
        let itemIndex = indexPath[1]
        
        switch sectionIndex {
        case 1:
            if itemIndex == 1 {
                self.input.inquiryTapTrigger.onNext(())
            } else if itemIndex == 2 {
                self.input.proposeTapTrigger.onNext(())
            }
        case 2:
            if itemIndex == 1 {
                self.input.termsTapTrigger.onNext(())
            } else if itemIndex == 2 {
                self.input.personalInfoTapTrigger.onNext(())
            } else if itemIndex == 4 {
                self.input.signoutTapTrigger.onNext(())
            } else if itemIndex == 5 {
                self.input.withDrawTapTrigger.onNext(())
            }
        default:
            break
        }
    }
}

// MARK: - Network

extension MyPageViewModel {
    func fetchMemberInfo() {
        self.myInfoTask = Task {
            do {
                let memberInfo = try await self.memberUseCase.getMemberInfomation(bearerToken: KeyChainManager.shared.read(account: .accessToken))
                await MainActor.run(body: {
                    self.input.nickname.onNext(memberInfo.nickname)
                    self.input.villagePeriod.onNext(memberInfo.resident.toVillagePeriod)
                    
                    self.input.fetchFinishTrigger.onNext(())
                })
                myInfoTask?.cancel()
            } catch (let error) {
                print(error)
            }
        }
    }
}

extension MyPageViewModel: MyPageViewModelType {
    func goToChangeNickname() {
        delegate.goToChangeNickname()
    }
    
    func goToMyTownReview() {
        delegate.goToMyTownReview()
    }
    
    func goToInquiry() {
        delegate.goToInquiry()
    }
    
    func goToPropose() {
        delegate.goToPropose()
    }
    
    func goToTerms() {
        delegate.goToTerms()
    }
    
    func goToPersonalInfo() {
        delegate.goToPersonalInfo()
    }
    
    func popUpSignout() {
        delegate.popUpSignout()
    }
    
    func popUpWithDraw() {
        delegate.popUpWithDraw()
    }
}
