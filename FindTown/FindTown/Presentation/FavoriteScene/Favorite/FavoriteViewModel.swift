//
//  Favorite1ViewModel.swift
//  FindTown
//
//  Created by 장선영 on 2023/01/18.
//

import UIKit
import Foundation
import FindTownCore
import RxSwift

protocol FavoriteViewModelType {
    func goToLogin()
    func goToTownIntroduce(cityCode: Int)
    func goToTownMap(cityCode: Int)
}

protocol FavoriteViewModelDelegate {
    func goToLogin()
    func goToTownIntroduce(cityCode: Int)
    func goToTownMap(cityCode: Int)
}

enum FavoriteViewStatus {
    /// 로그인하지 않은 사용자인 경우
    case anonymous
    /// 찜한 동네가 없는 경우
    case isEmpty
    /// 찜한 동네가 있는 경우
    case isPresent
}

final class FavoriteViewModel: BaseViewModel {
    
    let delegate: FavoriteViewModelDelegate
    
    struct Input {
        let signUpButtonTrigger = PublishSubject<Void>()
        let townIntroButtonTrigger = PublishSubject<Int>()
        let townMapButtonTrigger = PublishSubject<Int>()
        let favoriteButtonTrigger = PublishSubject<Int>()
    }
    
    struct Output {
        let viewStatus = PublishSubject<FavoriteViewStatus>()
        let favoriteDataSource = BehaviorSubject<[TownTableModel]>(value: [])
        var isFavorite = PublishSubject<Bool>()
        let errorNotice = PublishSubject<Void>()
    }
    
    let output = Output()
    let input = Input()
    
    // MARK: - UseCase
    
    let townUseCase: TownUseCase
    let authUseCase: AuthUseCase
    let memberUseCase: MemberUseCase
    
    // MARK: - Task
    
    private var favoriteListTask: Task<Void, Error>?
    private var favoriteTask: Task<Void, Error>?
    
    init(delegate: FavoriteViewModelDelegate,
         townUseCase: TownUseCase,
         authUseCase: AuthUseCase,
         memberUseCase: MemberUseCase) {
        
        self.delegate = delegate
        self.townUseCase = townUseCase
        self.authUseCase = authUseCase
        self.memberUseCase = memberUseCase
        
        super.init()
        self.bind()
    }
    
    func bind() {
        
        self.input.signUpButtonTrigger
            .subscribe(onNext: { [weak self] in
                self?.delegate.goToLogin()
            })
            .disposed(by: disposeBag)
        
        self.input.townIntroButtonTrigger
            .subscribe(onNext: { [weak self] cityCode in
                self?.delegate.goToTownIntroduce(cityCode: cityCode)
            })
            .disposed(by: disposeBag)
        
        self.input.favoriteButtonTrigger
            .subscribe(onNext: { [weak self] cityCode in
                self?.favorite(cityCode: cityCode)
            })
            .disposed(by: disposeBag)
        
        self.input.townMapButtonTrigger
            .subscribe(onNext: { [weak self] cityCode in
                self?.delegate.goToTownMap(cityCode: cityCode)
            })
            .disposed(by: disposeBag)
    }
}

extension FavoriteViewModel: FavoriteViewModelType {
    
    func goToLogin() {
        delegate.goToLogin()
    }
    
    func goToTownIntroduce(cityCode: Int) {
        delegate.goToTownIntroduce(cityCode: cityCode)
    }
    
    func goToTownMap(cityCode: Int) {
        delegate.goToTownMap(cityCode: cityCode)
    }
}

// MARK: 네트워크

extension FavoriteViewModel {
    
    // 찜 목록 불러오기
    func getFavoriteList() {
        if UserDefaultsSetting.isAnonymous {
            self.output.viewStatus.onNext(.anonymous)
        } else {
            self.favoriteListTask = Task {
                do {
                    let accessToken = try await self.authUseCase.getAccessToken()
                    let favoriteList = try await self.memberUseCase.getFavoriteList(accessToken: accessToken)
                    
                    await MainActor.run(body: {
                        favoriteList.isEmpty ? self.output.viewStatus.onNext(.isEmpty) : self.output.viewStatus.onNext(.isPresent)
                        self.output.favoriteDataSource.onNext(favoriteList)
                    })
                } catch(let error) {
                    await MainActor.run(body:  {
                        self.output.errorNotice.onNext(())
                    })
                    Log.error(error)
                }
                favoriteListTask?.cancel()
            }
        }
    }
    
    // 찜 등록, 해제
    func favorite(cityCode: Int) {
        self.favoriteTask = Task {
            do {
                let accessToken = try await self.authUseCase.getAccessToken()
                let favoriteStatus = try await self.memberUseCase.favorite(accessToken: accessToken,
                                                                           cityCode: cityCode)
                await MainActor.run(body: {
                    self.getFavoriteList()
                    self.output.isFavorite.onNext(favoriteStatus)
                })
            } catch (let error) {
                await MainActor.run(body: {
                    self.output.errorNotice.onNext(())
                })
                Log.error(error)
            }
    
            favoriteTask?.cancel()
        }
    }
}
