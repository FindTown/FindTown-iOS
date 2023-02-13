//
//  MyTownReviewViewModel.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/01.
//

import Foundation

import FindTownCore
import RxSwift
import RxRelay

protocol MyTownReviewViewModelType { }

final class MyTownReviewViewModel: BaseViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        var reviewTableDataSource = BehaviorRelay<[ReviewModel]>(value: [])
        let errorNotice = PublishSubject<Void>()
    }
    
    let input = Input()
    let output = Output()
    let delegate: MyPageViewModelDelegate
    
    // MARK: - UseCase
    
    let authUseCase: AuthUseCase
    let memberUseCase: MemberUseCase
    
    // MARK: - Task
    
    private var reviewTask: Task<Void, Error>?
    
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
        self.fetchReview()
    }
    
    func showErrorNoticeAlert() {
        self.output.errorNotice.onNext(())
    }
}

// MARK: - NetWork

extension MyTownReviewViewModel {
    func fetchReview() {
        self.reviewTask = Task {
            do {
                let memberInfo = try await self.memberUseCase.getMemberInfomation(bearerToken: authUseCase.getAccessToken())
                await MainActor.run(body: {
                    self.output.reviewTableDataSource.accept([memberInfo.resident.toEntity])
                })
                reviewTask?.cancel()
            } catch (let error) {
                Log.error(error)
                await MainActor.run(body: {
                    self.showErrorNoticeAlert()
                })
            }
            reviewTask?.cancel()
        }
    }
}
