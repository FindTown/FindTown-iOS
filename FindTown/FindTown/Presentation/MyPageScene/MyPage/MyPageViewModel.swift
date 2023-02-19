//
//  MyPageViewModel.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/31.
//

import UIKit

import FindTownCore
import FindTownNetwork
import RxSwift
import RxRelay

protocol MyPageViewModelDelegate {
    func goToChangeNickname()
    func goToMyTownReview()
    func goToInquiry()
    func goToPropose()
    func goToTerms()
    func goToPersonalInfo()
    func goToAuth()
    func fetchNickname(nickname: String)
}

protocol MyPageViewModelType {
    func goToChangeNickname()
    func goToMyTownReview()
    func goToInquiry()
    func goToPropose()
    func goToTerms()
    func goToPersonalInfo()
    func goToAuth()
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
        let signoutNotice = PublishSubject<Void>()
        let withDrawNotice = PublishSubject<Void>()
        let errorNotice = PublishSubject<Void>()
    }
    
    let input = Input()
    let output = Output()
    let delegate: MyPageViewModelDelegate
    
    // MARK: - UseCase
    
    let authUseCase: AuthUseCase
    let memberUseCase: MemberUseCase
    
    // MARK: - Task
    
    private var resignTask: Task<Void, Error>?
    private var logoutTask: Task<Void, Error>?
    private var myInformationTask: Task<Void, Error>?
    
    init(
        delegate: MyPageViewModelDelegate,
        authUseCase: AuthUseCase,
        memberUseCase: MemberUseCase
    ) {
        self.delegate = delegate
        self.authUseCase = authUseCase
        self.memberUseCase = memberUseCase
        
        super.init()
        self.bind()
    }
    
    func bind() {
        self.input.nickname
            .bind { [weak self] nickname in
                self?.output.myNickname.accept(nickname)
            }
            .disposed(by: disposeBag)
        
        self.input.villagePeriod
            .bind { [weak self] villagePeriod in
                self?.output.myVillagePeriod.accept(villagePeriod)
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
                self?.output.signoutNotice.onNext(())
            }
            .disposed(by: disposeBag)
        
        self.input.withDrawTapTrigger
            .bind {[weak self] in
                self?.output.withDrawNotice.onNext(())
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
    
    func showErrorNoticeAlert() {
        self.output.errorNotice.onNext(())
    }
}

// MARK: - Network

extension MyPageViewModel {
    func fetchMemberInformation() {
        self.myInformationTask = Task {
            do {
                let accessToken = try await authUseCase.getAccessToken()
                let memberInformation = try await self.memberUseCase.getMemberInformation(accessToken: accessToken)
                await MainActor.run(body: {
                    guard let resident = memberInformation.resident.first else { return }
                    let villagePeriod = "\(resident.residentAddress.split(separator: " ").last ?? "") 거주 ・ \(resident.residentYear)년 \(resident.residentMonth)개월"
                    self.input.nickname.onNext(memberInformation.nickname)
                    self.input.villagePeriod.onNext(villagePeriod)
                    self.input.fetchFinishTrigger.onNext(())
                })
                myInformationTask?.cancel()
            } catch (let error) {
                if let error = error as? FTNetworkError,
                   FTNetworkError.isUnauthorized(error: error) {
                    await MainActor.run (body: {
                        self.input.nickname.onNext("닉네임")
                        self.input.villagePeriod.onNext("거주 ・ 년 개월")
                        self.input.fetchFinishTrigger.onNext(())
                    })
                } else {
                    await MainActor.run(body: {
                        self.showErrorNoticeAlert()
                        self.input.nickname.onNext("닉네임")
                        self.input.villagePeriod.onNext("거주 ・ 년 개월")
                        self.input.fetchFinishTrigger.onNext(())
                    })
                }
                Log.error(error)
                myInformationTask?.cancel()
            }
        }
    }
    
    func logout() {
        self.logoutTask = Task {
            do {
                let accessToken = try await authUseCase.getAccessToken()
                let isLogout = try await self.memberUseCase.logout(accessToken: accessToken)
                
                await MainActor.run(body: {
                    isLogout ? self.goToAuth() : self.showErrorNoticeAlert()
                })
                logoutTask?.cancel()
            } catch (let error) {
                Log.error(error)
                await MainActor.run(body: {
                    self.showErrorNoticeAlert()
                })
            }
            logoutTask?.cancel()
        }
    }
    
    func resignMember() {
        self.resignTask = Task {
            do {
                let accessToken = try await authUseCase.getAccessToken()
                let isResign = try await self.memberUseCase.resign(accessToken: accessToken)
                
                await MainActor.run(body: {
                    isResign ? self.goToAuth() : self.showErrorNoticeAlert()
                })
                resignTask?.cancel()
            } catch (let error) {
                Log.error(error)
                await MainActor.run(body: {
                    self.showErrorNoticeAlert()
                })
            }
            resignTask?.cancel()
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
    
    func goToAuth() {
        delegate.goToAuth()
    }
}
