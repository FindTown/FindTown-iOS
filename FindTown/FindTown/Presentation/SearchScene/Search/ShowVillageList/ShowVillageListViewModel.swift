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

protocol ShowVillageListViewModelDelegate {
    func goToTownIntroduce(cityCode: Int)
    func goToTownMap(cityCode: Int)
}

protocol ShowVillageListViewModelType {
    func goToTownIntroduce(cityCode: Int)
    func goToTownMap(cityCode: Int)
}

final class ShowVillageListViewModel: BaseViewModel {
    
    struct Input {
        let fetchFinishTrigger = PublishSubject<Void>()
        let townIntroButtonTrigger = PublishSubject<Int>()
        let townMapButtonTrigger = PublishSubject<Int>()
    }
    
    struct Output {
        var searchTownTableDataSource = BehaviorRelay<[TownTableModel]>(value: [])
        let errorNotice = PublishSubject<Void>()
    }
    
    let input = Input()
    let output = Output()
    let delegate: ShowVillageListViewModelDelegate
    
    let selectCountyData: String?
    
    // MARK: - UseCase
    
    let townUseCase: TownUseCase
    
    // MARK: - Task
    
    private var searchTask: Task<Void, Error>?
    
    init(
        delegate: ShowVillageListViewModelDelegate,
        townUseCase: TownUseCase,
        selectCountyData: String?
    ) {
        self.delegate = delegate
        self.townUseCase = townUseCase
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
        
        self.input.townMapButtonTrigger
            .subscribe(onNext: { [weak self] cityCode in
                self?.delegate.goToTownMap(cityCode: cityCode)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Network

extension ShowVillageListViewModel {
    func fetchTownInformation() {
        self.searchTask = Task {
            do {
                guard let selectCountyData = self.selectCountyData else { return }
                let townInformation = try await self.townUseCase.getSearchTownInformation(countyData: selectCountyData)
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
}

// MARK: - Delegate

extension ShowVillageListViewModel: ShowVillageListViewModelDelegate {
    
    func goToTownIntroduce(cityCode: Int) {
        delegate.goToTownIntroduce(cityCode: cityCode)
    }
    
    func goToTownMap(cityCode: Int) {
        delegate.goToTownMap(cityCode: cityCode)
    }
}
