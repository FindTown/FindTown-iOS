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
        //        let review = PublishSubject<reviewModelTest>()
    }
    
    struct Output {
        var reviewTableDataSource = BehaviorRelay<[ReviewModel]>(value: [])
    }
    
    let input = Input()
    let output = Output()
    let delegate: MyPageViewModelDelegate
    
    // MARK: - UseCase
    
    let memberUseCase: MemberUseCase
    
    // MARK: - Task
    
    private var reviewTask: Task<Void, Error>?
    
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
        self.fetchReview()
    }
}

// MARK: - NetWork

extension MyTownReviewViewModel {
    func fetchReview() {
        self.reviewTask = Task {
            do {
                let memberInfo = try await self.memberUseCase.getMemberInfomation(bearerToken: KeyChainManager.shared.read(account: .accessToken))
                await MainActor.run(body: {
                    self.output.reviewTableDataSource.accept([memberInfo.resident.toEntity])
                })
                reviewTask?.cancel()
            } catch (let error) {
                print(error)
            }
        }
    }
}
