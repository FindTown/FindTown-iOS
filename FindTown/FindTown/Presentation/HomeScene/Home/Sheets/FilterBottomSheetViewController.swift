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
    
    private var viewModel: FilterBottomSheetViewModel?
    private let screenWidth = UIScreen.main.bounds.width
    private var selectedCells: [IndexPath] = []
    private var selectedCellsString: [String] = []
    
    // MARK: - Views
    
    private let titleLabel = FindTownLabel(text: "필터", font: .subtitle4)
    
    private let infraLabel = FindTownLabel(text: "인프라", font: .subtitle4)
    private let infraGuirdLabel = FindTownLabel(text: "원하는 인프라를 1개 선택해주세요.",
                                                font: .body3, textColor: .grey5)
    
    private let infraIconStackView = InfraIconStackView()
    
    private let trafficLabel = FindTownLabel(text: "교통", font: .subtitle4)
    private let trafficGuirdLabel = FindTownLabel(text: "선호하는 지하철 노선을 최대 3개 선택해주세요.",
                                                  font: .body3, textColor: .grey5)
    
    private let trafficCollectionView = TrafficCollectionView()
    
    private let confirmButton = FTButton(style: .largeFilled)
    
    // MARK: - Life Cycle
    
    init(viewModel: FilterBottomSheetViewModel) {
        super.init(bottomHeight: UIScreen.main.bounds.height * 0.85)
        self.viewModel = viewModel
    }
    
    override init(bottomHeight: CGFloat) {
        super.init(bottomHeight: bottomHeight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addView() {
        super.addView()
        
        [titleLabel, infraLabel, infraGuirdLabel, infraIconStackView,
         trafficLabel, trafficGuirdLabel, trafficCollectionView, confirmButton].forEach {
            bottomSheetView.addSubview($0)
        }
    }
    
    override func setLayout() {
        super.setLayout()
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: bottomSheetView.topAnchor,
                                            constant: screenWidth * 0.055),
            titleLabel.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            infraLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                            constant: screenWidth * 0.035),
            infraLabel.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            infraGuirdLabel.topAnchor.constraint(equalTo: infraLabel.bottomAnchor,
                                                 constant: screenWidth * 0.040),
            infraGuirdLabel.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            infraIconStackView.topAnchor.constraint(equalTo: infraGuirdLabel.bottomAnchor,
                                                    constant: screenWidth * 0.040),
            infraIconStackView.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 32),
            infraIconStackView.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor, constant: -32)
        ])
        
        NSLayoutConstraint.activate([
            trafficLabel.topAnchor.constraint(equalTo: infraIconStackView.bottomAnchor,
                                              constant: screenWidth * 0.055),
            trafficLabel.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            trafficGuirdLabel.topAnchor.constraint(equalTo: trafficLabel.bottomAnchor,
                                                   constant: screenWidth * 0.040),
            trafficGuirdLabel.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 16)
        ])
        
        trafficCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trafficCollectionView.topAnchor.constraint(equalTo: trafficGuirdLabel.bottomAnchor, constant: 24),
            trafficCollectionView.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 16),
            trafficCollectionView.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor, constant: -16),
            trafficCollectionView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            confirmButton.bottomAnchor.constraint(equalTo: bottomSheetView.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            confirmButton.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 16),
            confirmButton.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor, constant: -16),
        ])
    }
    
    override func setupView() {
        super.setupView()
        
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
                guard let infra else { return }
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
