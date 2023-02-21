//
//  GuSelectDongViewModel.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/24.
//

import Foundation

import FindTownCore
import RxSwift
import RxRelay

protocol ShowVillageListViewModelType {
    func goToTownIntroduce(cityCode: Int)
    func goToAuth()
}

final class ShowVillageListViewModel: BaseViewModel {
    
    struct Input {
        let fetchFinishTrigger = PublishSubject<Void>()
        let townIntroButtonTrigger = PublishSubject<Int>()
        let favoriteButtonTrigger = PublishSubject<Int>()
        let goToAuthButtonTrigger = PublishSubject<Void>()
    }
    
    struct Output {
        var searchTownTableDataSource = BehaviorRelay<[TownTableModel]>(value: [])
        let errorNotice = PublishSubject<Void>()
    }
    
    let input = Input()
    let output = Output()
    let delegate: SearchViewModelDelegate
    
    let selectCountyData: String?
    
    // MARK: - UseCase
    
    let townUseCase: TownUseCase
    let authUseCase: AuthUseCase
    let memberUseCase: MemberUseCase
    
    // MARK: - Task
    
    private var searchTask: Task<Void, Error>?
    private var favoriteTask: Task<Void, Error>?
    
    init(
        delegate: SearchViewModelDelegate,
        townUseCase: TownUseCase,
        authUseCase: AuthUseCase,
        memberUseCase: MemberUseCase,
        selectCountyData: String?
    ) {
        self.delegate = delegate
        self.townUseCase = townUseCase
        self.authUseCase = authUseCase
        self.memberUseCase = memberUseCase
        self.selectCountyData = selectCountyData
        
        super.init()
        self.bind()
    }
    
    func bind() {
        
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
        
        self.input.goToAuthButtonTrigger
            .subscribe(onNext: { [weak self] in
                self?.goToAuth()
            })
            .disposed(by: disposeBag)
    }
}


extension ShowVillageListViewModel: ShowVillageListViewModelType {
    
    func goToTownIntroduce(cityCode: Int) {
        delegate.goToTownIntroduce(cityCode: cityCode)
    }
    
    func goToAuth() {
        delegate.goToAuth()
    }
}

// MARK: - Network

extension ShowVillageListViewModel {
    func fetchTownInformation() {
        self.searchTask = Task {
            do {
                var accessToken = ""
                if !UserDefaultsSetting.isAnonymous {
                    accessToken = try await self.authUseCase.getAccessToken()
                }
                guard let selectCountyData = self.selectCountyData else { return }
                let townInformation = try await self.townUseCase.getSearchTownInformation(countyData: selectCountyData,
                                                                                          accessToken: accessToken)
                await MainActor.run(body: {
                    let townTableModel = townInformation.toEntity
                    self.output.searchTownTableDataSource.accept(townTableModel)
                })
                searchTask?.cancel()
            } catch (let error) {
                await MainActor.run {
                    self.output.errorNotice.onNext(())
                }
                Log.error(error)
            }
            searchTask?.cancel()
        }
    }
    
    // 찜 등록, 해제
    func favorite(cityCode: Int) {
        self.favoriteTask = Task {
            do {
                let accessToken = try await self.authUseCase.getAccessToken()
                let favoriteStatus = try await self.memberUseCase.favorite(accessToken: accessToken,
                                                                           cityCode: cityCode)
                
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
