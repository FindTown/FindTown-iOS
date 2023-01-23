//
//  HomeViewController.swift
//  FindTown
//
//  Created by 이호영 on 2022/12/25.
//

import UIKit

import FindTownCore
import FindTownUI
import RxCocoa
import RxSwift

final class HomeViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let viewModel: HomeViewModel?
    
    // MARK: - Views
    
    private let tempLogo = FindTownLabel(text: "LOGO", font: .subtitle1, textColor: .primary)
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "search"), for: .normal)
        return button
    }()
    private let logoSearchStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let dongSearchTitle = FindTownLabel(text: "나에게 맞는 동네 찾기", font: .headLine3)
    
    private let filterResetButton = FTButton(style: .buttonFilterNormal)
    private let filterButton = FTButton(style: .buttonFilter)
    private let filterCollectionView = FilterCollectionView()
    private let filterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        return stackView
    }()
    
    private let townRecommendationTitle = FindTownLabel(text: "동네 리스트", font: .subtitle2, textColor: .grey6)
    private let townCountTitle = FindTownLabel(text: "", font: .label1, textColor: .grey6)
    private let townListAndCountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let emptyView = UIView()
    private let checkBox = CheckBox()
    private let safetyTitle = FindTownLabel(text: "안전 점수가 높은", font: .label1, textColor: .grey6)
    private let infoIcon = UIImageView(image: UIImage(systemName: "info.circle"))
    private let safetyScoreStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private let townTableView = TownTableView()
    
    private let townListBackgroundView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Life Cycle
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Functions
    
    override func addView() {
        super.addView()
        
        [tempLogo, searchButton].forEach {
            logoSearchStackView.addArrangedSubview($0)
        }
        
        [filterResetButton, filterButton, filterCollectionView].forEach {
            filterStackView.addArrangedSubview($0)
        }
        
        [townRecommendationTitle, townCountTitle].forEach {
            townListAndCountStackView.addArrangedSubview($0)
        }
        
        [emptyView, checkBox, safetyTitle, infoIcon].forEach {
            safetyScoreStackView.addArrangedSubview($0)
        }
        
        [townListAndCountStackView, safetyScoreStackView, townTableView].forEach {
            townListBackgroundView.addArrangedSubview($0)
        }
        
        [logoSearchStackView, dongSearchTitle, filterStackView, townListBackgroundView].forEach {
            self.stackView.addArrangedSubview($0)
        }
    }
    
    override func setLayout() {
        super.setLayout()
        
        stackView.setCustomSpacing(56, after: logoSearchStackView)
        stackView.setCustomSpacing(16, after: dongSearchTitle)
        stackView.setCustomSpacing(40, after: filterStackView)
        
        townListBackgroundView.setCustomSpacing(16, after: townListAndCountStackView)
        townListBackgroundView.setCustomSpacing(10, after: safetyScoreStackView)
        
        townListBackgroundView.layoutMargins = UIEdgeInsets(top: 24, left: 0, bottom: 16, right: 0)
        townListBackgroundView.isLayoutMarginsRelativeArrangement = true
        
        [logoSearchStackView, filterStackView, townListAndCountStackView, safetyScoreStackView].forEach {
            $0.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            $0.isLayoutMarginsRelativeArrangement = true
        }
        
        dongSearchTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dongSearchTitle.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16)
        ])
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        NSLayoutConstraint.activate([
            townTableView.heightAnchor.constraint(equalToConstant: townTableView.contentSize.height),
        ])
    }
    
    override func setupView() {
        filterResetButton.setImage(UIImage(named: "reset"), for: .normal)
        filterResetButton.setTitle("초기화", for: .normal)
        filterResetButton.configuration?.contentInsets.leading = 12
        filterResetButton.configuration?.contentInsets.trailing = 12
        filterResetButton.setTitleColor(FindTownColor.black.color, for: .normal)
        filterResetButton.isHidden = true
        
        filterButton.setImage(UIImage(named: "filter"), for: .normal)
        filterButton.changesSelectionAsPrimaryAction = false
        filterButton.setTitle("필터", for: .normal)
        filterButton.configuration?.contentInsets.leading = 12
        filterButton.configuration?.contentInsets.trailing = 12
        filterButton.setTitleColor(FindTownColor.black.color, for: .normal)
        
        townListBackgroundView.backgroundColor = FindTownColor.back2.color
        
        townTableView.rowHeight = 150
        townTableView.estimatedRowHeight = 150
    }
    
    override func bindViewModel() {
        
        filterCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        // Input
        
        filterButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                self?.viewModel?.input.filterButtonTrigger.onNext(())
            }
            .disposed(by: disposeBag)
        
        filterResetButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                self?.FilterResetButtonHidden(true)
                self?.viewModel?.input.resetButtonTrigger.onNext(())
            }
            .disposed(by: disposeBag)
        
        // Output
        
        viewModel?.output.searchFilterDataSource
            .observe(on: MainScheduler.instance)
            .bind(to: filterCollectionView.rx.items(
                cellIdentifier: FillterCollectionViewCell.reuseIdentifier,
                cellType: FillterCollectionViewCell.self)) { index, item, cell in
                    
                    cell.setupCell(item, index)
                    
                }.disposed(by: disposeBag)
        
        viewModel?.output.searchTownTableDataSource
            .observe(on: MainScheduler.instance)
            .bind(to: townTableView.rx.items(
                cellIdentifier: TownTableViewCell.reuseIdentifier,
                cellType: TownTableViewCell.self)) { index, item, cell in
                    
                    cell.setupCell(item)
                    
                }.disposed(by: disposeBag)
        
        viewModel?.output.searchTownTableDataSource
            .observe(on: MainScheduler.instance)
            .bind { [weak self] in
                self?.townCountTitle.text = "\($0.count)개 동네"
            }
            .disposed(by: disposeBag)
    }
    
    func dismissBottomSheet(_ tempModel: TempFilterModel) {
        
        FilterResetButtonHidden(false)
        
        var tempTraffic = "교통"
        if let first = tempModel.traffic.first {
            tempTraffic = tempModel.traffic.count == 1 ? first : first + " 외 \(tempModel.traffic.count - 1) 건"
        }
        
        let tempInfra = tempModel.infra == "" ? "인프라" : tempModel.infra
        
        viewModel?.output.searchFilterDataSource.accept([tempInfra, tempTraffic])
    }
    
    private func FilterResetButtonHidden(_ isHidden: Bool) {
        filterResetButton.isHidden = isHidden
        filterButton.isHidden = !isHidden
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath)
    -> CGSize {
        if let filter = viewModel?.output.searchFilterDataSource.value[indexPath.row] {
            return CGSize(width: filter.size(
                withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]
            ).width + 40, height: 40)
        }
        return CGSize(width: 100, height: 40)
    }
}
