//
//  FilterBottomSheetViewController.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/16.
//

import UIKit

import FindTownUI
import FindTownCore
import RxSwift
import RxCocoa

final class FilterBottonSheetViewController: BaseBottomSheetViewController {
    
    // MARK: - Properties
    
    private var filterSheetType: FilterSheetType?
    private var filterDataSource: FilterModel?
    private var viewModel: FilterBottomSheetViewModel?
    private let screenWidth = UIScreen.main.bounds.width
    private var selectedCells: [IndexPath] = []
    private var selectedCellsString: [String] = []
    
    // MARK: - Views
    
    private let filterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private let spacingView = UIView()
    private let titleLabel = FindTownLabel(text: "필터", font: .subtitle4, textAlignment: .center)
    
    private let infraLabel = FindTownLabel(text: "인프라", font: .subtitle4)
    private let infraGuideLabel = FindTownLabel(text: "원하는 인프라를 1개 선택해주세요.",
                                                font: .body3, textColor: .grey5)
    
    private let infraIconStackView = InfraIconStackView()
    
    private let trafficLabel = FindTownLabel(text: "교통", font: .subtitle4)
    private let trafficGuideLabel = FindTownLabel(text: "선호하는 지하철 노선을 최대 3개 선택해주세요.",
                                                  font: .body3, textColor: .grey5)
    
    private let trafficCollectionView = TrafficCollectionView()
    
    private let confirmButton = FTButton(style: .largeFilled)
    
    // MARK: - Life Cycle
    
    init(viewModel: FilterBottomSheetViewModel, filterSheetType: FilterSheetType, filterDataSource: FilterModel) {
        self.filterSheetType = filterSheetType
        self.filterDataSource = filterDataSource
        self.viewModel = viewModel
        
        if filterSheetType == .Infra {
            self.viewModel?.input.traffic.onNext(filterDataSource.traffic)
            self.viewModel?.input.infra.onNext(filterDataSource.infra)
        } else {
            self.viewModel?.input.infra.onNext(filterDataSource.infra)
            self.viewModel?.input.traffic.onNext(filterDataSource.traffic)
        }
        self.viewModel?.input.trafficIndexPath.onNext(filterDataSource.trafficIndexPath)
        
        super.init(bottomHeight: UIScreen.main.bounds.height * filterSheetType.height)
    }
    
    override init(bottomHeight: CGFloat) {
        super.init(bottomHeight: bottomHeight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addView() {
        super.addView()
        
        [spacingView, titleLabel, infraLabel, infraGuideLabel, infraIconStackView,
         trafficLabel, trafficGuideLabel, trafficCollectionView].forEach {
            filterStackView.addArrangedSubview($0)
        }
        
        [filterStackView, confirmButton].forEach {
            bottomSheetView.addSubview($0)
        }
    }
    
    override func setLayout() {
        super.setLayout()
        
        NSLayoutConstraint.activate([
            filterStackView.topAnchor.constraint(equalTo: bottomSheetView.topAnchor),
            filterStackView.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 16),
            filterStackView.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            trafficCollectionView.leadingAnchor.constraint(equalTo: filterStackView.leadingAnchor),
            trafficCollectionView.trailingAnchor.constraint(equalTo: filterStackView.trailingAnchor),
            trafficCollectionView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            confirmButton.bottomAnchor.constraint(equalTo: bottomSheetView.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            confirmButton.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 16),
            confirmButton.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor, constant: -16),
        ])
        
        infraIconStackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        infraIconStackView.isLayoutMarginsRelativeArrangement = true
        
        filterStackView.setCustomSpacing(24, after: spacingView)
        filterStackView.setCustomSpacing(screenWidth * 0.040, after: titleLabel)
        filterStackView.setCustomSpacing(screenWidth * 0.040, after: infraLabel)
        filterStackView.setCustomSpacing(screenWidth * 0.040, after: infraGuideLabel)
        filterStackView.setCustomSpacing(screenWidth * 0.055, after: infraIconStackView)
        filterStackView.setCustomSpacing(screenWidth * 0.040, after: trafficLabel)
        filterStackView.setCustomSpacing(24, after: trafficGuideLabel)
    }
    
    override func setupView() {
        super.setupView()
        
        guard let filterDataSource = self.filterDataSource else { return }
        selectedCellsString = filterDataSource.traffic
        selectedCells = filterDataSource.trafficIndexPath
        infraIconStackView.setupButtonSelected(infra: filterDataSource.infra)
        
        if filterSheetType == .Infra {
            titleLabel.text = " "
            [spacingView, trafficLabel, trafficGuideLabel, trafficCollectionView].forEach {
                $0.isHidden = true
            }
        }
        
        else if filterSheetType == .Traffic {
            titleLabel.text = " "
            [spacingView, infraLabel, infraGuideLabel, infraIconStackView].forEach {
                $0.isHidden = true
            }
        }
        
        confirmButton.setTitle("적용하기", for: .normal)
        confirmButton.isEnabled = false
        
        trafficCollectionView.reloadData()
    }
    
    override func bindViewModel() {
        
        trafficCollectionView.rx.setDelegate(self)
                    .disposed(by: disposeBag)
        
        // Input
        
        confirmButton.rx.tap
            .bind { [weak self] in
                self?.setBottomSheetStatus(to: .hide)
                self?.viewModel?.input.completeButtonTrigger.onNext(())
            }
            .disposed(by: disposeBag)
        
        infraIconStackView.rx.didSelectInfraIcon
            .bind { [weak self] infra in
                guard let infra = infra else { return }
                self?.viewModel?.input.infra.onNext(infra)
            }
            .disposed(by: disposeBag)
        
        trafficCollectionView.rx.itemSelected
            .bind { [weak self] indexPath in
                self?.handleSelection(at: indexPath)
            }
            .disposed(by: disposeBag)
        
        // Output
        
        viewModel?.output.trafficDataSource
            .bind(to: trafficCollectionView.rx.items(
                cellIdentifier: TrafficCollectionViewCell.reuseIdentifier,
                cellType: TrafficCollectionViewCell.self)) { index, item, cell in
                    
                    guard let traffics = self.filterDataSource?.traffic else { return }
                    cell.setupCell(itemText: item.description, traffics: traffics)
                    
                }.disposed(by: disposeBag)
        
        viewModel?.output.buttonsSelected
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive { [weak self] in
                self?.confirmButton.isSelected = $0
                self?.confirmButton.isEnabled = $0
            }
            .disposed(by: disposeBag)
    }
}

private extension FilterBottonSheetViewController {
    func handleSelection(at indexPath: IndexPath) {
        if selectedCellsString.contains(Traffic.allCases[indexPath.row].description) {
            removeTrafficCell(at: indexPath)
        } else {
            addTrafficCell(at: indexPath)
        }
    }
    
    func removeTrafficCell(at indexPath: IndexPath) {
        if let index = selectedCells.firstIndex(where: { $0 == indexPath }) {
            selectedCells.remove(at: index)
            selectedCellsString.remove(at: index)
        }
        viewModel?.input.traffic.onNext(selectedCellsString)
        viewModel?.input.trafficIndexPath.onNext(selectedCells)
        
        if let cell = trafficCollectionView.cellForItem(at: indexPath) as? TrafficCollectionViewCell {
            cell.nameButton.isSelected = false
        }
    }
    
    func addTrafficCell(at indexPath: IndexPath) {
        if selectedCells.count >= 3 {
            let firstIndexPath = selectedCells.removeFirst()
            trafficCollectionView.deselectItem(at: firstIndexPath, animated: true)
            _ = selectedCellsString.removeFirst()
            
            if let cell = trafficCollectionView.cellForItem(at: firstIndexPath) as? TrafficCollectionViewCell {
                cell.nameButton.isSelected = false
            }
        }
        selectedCells.append(indexPath)
        selectedCellsString.append(Traffic.allCases[indexPath.row].description)
        viewModel?.input.traffic.onNext(selectedCellsString)
        viewModel?.input.trafficIndexPath.onNext(selectedCells)
        
        if let cell = trafficCollectionView.cellForItem(at: indexPath) as? TrafficCollectionViewCell {
            cell.nameButton.isSelected = true
        }
    }
}

extension FilterBottonSheetViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let itemSizeWidth = screenWidth * 0.200
        return itemSizeWidth / 5
    }
}
