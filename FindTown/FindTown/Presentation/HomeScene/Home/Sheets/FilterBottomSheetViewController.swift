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
    private var filterDataSource: TempFilterModel?
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
    
    init(viewModel: FilterBottomSheetViewModel, filterSheetType: FilterSheetType, filterDataSource: TempFilterModel) {
        self.filterSheetType = filterSheetType
        self.filterDataSource = filterDataSource
        self.viewModel = viewModel
        
        self.viewModel?.input.infra.onNext(filterDataSource.infra)
        self.viewModel?.input.traffic.onNext(filterDataSource.traffic)
        
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
        
        [titleLabel, infraLabel, infraGuideLabel, infraIconStackView,
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
            titleLabel.topAnchor.constraint(equalTo: filterStackView.topAnchor,
                                            constant: screenWidth * 0.055),
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
        
        filterStackView.setCustomSpacing(screenWidth * 0.040, after: titleLabel)
        filterStackView.setCustomSpacing(screenWidth * 0.040, after: infraLabel)
        filterStackView.setCustomSpacing(screenWidth * 0.040, after: infraGuideLabel)
        filterStackView.setCustomSpacing(screenWidth * 0.055, after: infraIconStackView)
        filterStackView.setCustomSpacing(screenWidth * 0.040, after: trafficLabel)
        filterStackView.setCustomSpacing(24, after: trafficGuideLabel)
    }
    
    override func setupView() {
        super.setupView()
        
        if filterSheetType == .Infra {
            self.viewModel?.input.infra.onNext("")
            titleLabel.text = ""
            [trafficLabel, trafficGuideLabel, trafficCollectionView].forEach {
                $0.isHidden = true
            }
        }
        
        else if filterSheetType == .Traffic {
            self.viewModel?.input.traffic.onNext([])
            titleLabel.text = ""
            [infraLabel, infraGuideLabel, infraIconStackView].forEach {
                $0.isHidden = true
            }
        }
        
        confirmButton.setTitle("적용하기", for: .normal)
        confirmButton.isEnabled = false
    }
    
    override func bindViewModel() {
        
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
                if self?.selectedCells.count ?? 0 >= 3 {
                    self?.trafficCollectionView.deselectItem(
                        at: self?.selectedCells.removeFirst() ?? IndexPath.init(),
                        animated: true
                    )
                    _ = self?.selectedCellsString.removeFirst()
                }
                self?.selectedCells.append(indexPath)
                self?.selectedCellsString.append(Traffic.allCases[indexPath.row].description)
                self?.viewModel?.input.traffic.onNext(self?.selectedCellsString ?? [])
            }
            .disposed(by: disposeBag)
        
        trafficCollectionView.rx.itemDeselected
            .bind { [weak self] indexPath in
                if let index = self?.selectedCells.firstIndex(where: {$0 == indexPath}) {
                    self?.selectedCells.remove(at: index)
                    self?.selectedCellsString.remove(at: index)
                }
                self?.viewModel?.input.traffic.onNext(self?.selectedCellsString ?? [])
            }
            .disposed(by: disposeBag)
        
        // Output
        
        viewModel?.output.trafficDataSource
            .bind(to: trafficCollectionView.rx.items(
                cellIdentifier: TrafficCollectionViewCell.reuseIdentifier,
                cellType: TrafficCollectionViewCell.self)) { index, item, cell in
                    cell.setupCell(itemText: item.description)
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
