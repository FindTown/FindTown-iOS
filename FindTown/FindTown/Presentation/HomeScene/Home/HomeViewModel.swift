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
}

protocol HomeViewModelType {
    func goToFilterBottomSheet(filterSheetType: FilterSheetType, filterDataSource: FilterModel)
    func goToGuSearchView()
}

final class HomeViewModel: BaseViewModel {
    
    struct Input {
        let resetButtonTrigger = PublishSubject<Void>()
        let filterButtonTrigger = PublishSubject<FilterSheetType>()
        let searchButtonTrigger = PublishSubject<Void>()
        let fetchFinishTrigger = PublishSubject<Void>()
        let safetySortTrigger = PublishSubject<Bool>()
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
    
    // MARK: - Task
    
    private var townTask: Task<Void, Error>?
    
    init(
        delegate: HomeViewModelDelegate,
        authUseCase: AuthUseCase,
        townUseCase: TownUseCase
    ) {
        self.delegate = delegate
        self.authUseCase = authUseCase
        self.townUseCase = townUseCase
        
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
                    let townTableMockData = TownTableMockData()
                    self.setTownTableView([townTableMockData])
                }
                Log.error(error)
            }
            townTask?.cancel()
        }
    }
    
    private func setTownTableView(_ townTableModel: [TownTableModel]) {
        self.output.searchTownTableDataSource.accept(townTableModel)
        self.input.fetchFinishTrigger.onNext(())
    }
}


extension HomeViewModel: HomeViewModelType {
    
    func goToFilterBottomSheet(filterSheetType: FilterSheetType, filterDataSource: FilterModel) {
        delegate.goToFilterBottomSheet(filterSheetType: filterSheetType, filterDataSource: filterDataSource)
    }
    
    func goToGuSearchView() {
        delegate.goToGuSearchView()
    }
}
