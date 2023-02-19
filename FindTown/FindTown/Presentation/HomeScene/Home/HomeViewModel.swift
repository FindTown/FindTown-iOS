//
//  HomeViewModel.swift
//  FindTown
//
//  Created by 이호영 on 2022/12/25.
//

import Foundation

import FindTownCore
import FindTownNetwork
import RxSwift
import RxRelay

protocol HomeViewModelDelegate {
    func goToFilterBottomSheet(filterSheetType: FilterSheetType, filterDataSource: FilterModel)
    func goToGuSearchView()
    func goToTownIntroduce(cityCode: Int)
}

protocol HomeViewModelType {
    func goToFilterBottomSheet(filterSheetType: FilterSheetType, filterDataSource: FilterModel)
    func goToGuSearchView()
    func goToTownIntroduce(cityCode: Int)
}

final class HomeViewModel: BaseViewModel {
    
    struct Input {
        let resetButtonTrigger = PublishSubject<Void>()
        let filterButtonTrigger = PublishSubject<FilterSheetType>()
        let searchButtonTrigger = PublishSubject<Void>()
        let fetchFinishTrigger = PublishSubject<Void>()
        let setEmptyViewTrigger = PublishSubject<Void>()
        let setNetworkErrorViewTrigger = PublishSubject<Void>()
        let safetySortTrigger = PublishSubject<Bool>()
        let townIntroButtonTrigger = PublishSubject<Int>()
        let favoriteButtonTrigger = PublishSubject<Int>()
    }
    
    struct Output {
        var searchFilterStringDataSource = BehaviorRelay<[String]>(value: ["인프라", "교통"])
        var searchFilterModelDataSource = BehaviorRelay<FilterModel>(value: FilterModel.init())
        var searchTownTableDataSource = BehaviorRelay<[TownTableModel]>(value: [])
        let errorNotice = PublishSubject<Void>()
    }
    
    let input = Input()
    let output = Output()
    let delegate: HomeViewModelDelegate
    
    private let searchCategoryData = ["인프라", "교통"]
    
    // MARK: - UseCase
    
    let authUseCase: AuthUseCase
    let townUseCase: TownUseCase
    let memberUseCase: MemberUseCase
    
    // MARK: - Task
    
    private var townTask: Task<Void, Error>?
    private var favoriteTask: Task<Void, Error>?
    
    init(
        delegate: HomeViewModelDelegate,
        authUseCase: AuthUseCase,
        townUseCase: TownUseCase,
        memberUseCase: MemberUseCase
    ) {
        self.delegate = delegate
        self.authUseCase = authUseCase
        self.townUseCase = townUseCase
        self.memberUseCase = memberUseCase
        
        super.init()
        self.bind()
    }
    
    func bind() {
        
        self.input.searchButtonTrigger
            .bind(onNext: goToGuSearchView)
            .disposed(by: disposeBag)
        
        self.input.resetButtonTrigger
            .withLatestFrom(input.resetButtonTrigger)
            .bind { [weak self] in
                guard let searchCategoryData = self?.searchCategoryData else { return }
                self?.output.searchFilterStringDataSource.accept(searchCategoryData)
                self?.output.searchFilterModelDataSource.accept(FilterModel.init())
                self?.fetchTownInformation()
            }
            .disposed(by: disposeBag)
        
        self.input.filterButtonTrigger
            .withLatestFrom(input.filterButtonTrigger)
            .bind { [weak self] filterType in
                guard let dataSource = self?.output.searchFilterModelDataSource.value else { return }
                self?.goToFilterBottomSheet(filterSheetType: filterType,
                                            filterDataSource: dataSource)
            }
            .disposed(by: disposeBag)
        
        self.input.safetySortTrigger
            .bind { [weak self] isSafetyHigh in
                guard let dataSource = self?.output.searchTownTableDataSource.value else { return }
                let sortedValue = dataSource.sorted { isSafetyHigh ? $0.safetyRate > $1.safetyRate : $0.safetyRate < $1.safetyRate}
                self?.output.searchTownTableDataSource.accept(sortedValue)
            }
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
    }
}

// MARK: - NetWork

extension HomeViewModel {
    func fetchTownInformation(filterStatus: String = "", subwayList: [String] = []) {
        self.townTask = Task {
            do {
                let townInformation = try await self.townUseCase.getTownInformation(filterStatus: filterStatus,
                                                                                    subwayList: subwayList)
                await MainActor.run(body: {
                    let townTableModel = townInformation.toEntity
                    self.setTownTableView(townTableModel)
                })
            } catch (let error) {
                await MainActor.run {
                    self.output.errorNotice.onNext(())
                    self.setNetworkErrorTownTableView()
                }
                Log.error(error)
            }
            townTask?.cancel()
        }
    }
    
    private func setTownTableView(_ townTableModel: [TownTableModel]) {
        self.input.fetchFinishTrigger.onNext(())
        if townTableModel.isEmpty {
            self.input.setEmptyViewTrigger.onNext(())
        }
        self.output.searchTownTableDataSource.accept(townTableModel)
    }
    
    private func setNetworkErrorTownTableView() {
        self.input.fetchFinishTrigger.onNext(())
        self.input.setNetworkErrorViewTrigger.onNext(())
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

extension HomeViewModel: HomeViewModelType {
    
    func goToFilterBottomSheet(filterSheetType: FilterSheetType, filterDataSource: FilterModel) {
        delegate.goToFilterBottomSheet(filterSheetType: filterSheetType, filterDataSource: filterDataSource)
    }
    
    func goToGuSearchView() {
        delegate.goToGuSearchView()
    }
    
    func goToTownIntroduce(cityCode: Int) {
        delegate.goToTownIntroduce(cityCode: cityCode)
    }
}
