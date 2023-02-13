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
    
    private let spacingView = UIView()
    
    private let homeLogo = UIImageView(image: UIImage(named: "homeLogo"))
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "search"), for: .normal)
        return button
    }()
    
    private let villageSearchTitle = FindTownLabel(text: "나에게 맞는 동네 찾기", font: .headLine3)
    
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
    
    private let townListImageView = UIImageView()
    private let townRecommendationTitle = FindTownLabel(text: "동네 리스트", font: .subtitle2, textColor: .grey6)
    private let townImageTitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    private let townCountTitle = FindTownLabel(text: "", font: .label1, textColor: .grey6)
    private let townListAndCountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let safetyEmptyView = UIView()
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
    
    private let townListTitleAndSafeScoreView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        return stackView
    }()
    
    private let tableViewHeaderView = UIView()
    
    private let townTableView = TownTableView()
    
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
        [filterResetButton, filterButton, filterCollectionView].forEach {
            filterStackView.addArrangedSubview($0)
        }
        
        [townListImageView, townRecommendationTitle].forEach {
            townImageTitleStackView.addArrangedSubview($0)
        }
        
        [townImageTitleStackView, townCountTitle].forEach {
            townListAndCountStackView.addArrangedSubview($0)
        }
        
        [safetyEmptyView, checkBox, safetyTitle, infoIcon].forEach {
            safetyScoreStackView.addArrangedSubview($0)
        }
        
        [townListAndCountStackView, safetyScoreStackView].forEach {
            townListTitleAndSafeScoreView.addArrangedSubview($0)
        }
        
        [spacingView, villageSearchTitle, filterStackView, townListTitleAndSafeScoreView].forEach {
            tableViewHeaderView.addSubview($0)
        }
        
        view.addSubview(townTableView)
        townTableView.tableHeaderView = tableViewHeaderView
    }
    
    override func setLayout() {
        tableViewHeaderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableViewHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableViewHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableViewHeaderView.heightAnchor.constraint(equalToConstant: 280)
        ])
        
        spacingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spacingView.topAnchor.constraint(equalTo: tableViewHeaderView.topAnchor, constant: 40),
        ])
        
        NSLayoutConstraint.activate([
            villageSearchTitle.topAnchor.constraint(equalTo: spacingView.topAnchor, constant: 16),
            villageSearchTitle.leftAnchor.constraint(equalTo: tableViewHeaderView.leftAnchor, constant: 16),
        ])
        
        NSLayoutConstraint.activate([
            filterStackView.topAnchor.constraint(equalTo: villageSearchTitle.topAnchor, constant: 40),
            filterStackView.leftAnchor.constraint(equalTo: tableViewHeaderView.leftAnchor, constant: 16),
            filterStackView.trailingAnchor.constraint(equalTo: tableViewHeaderView.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            townListTitleAndSafeScoreView.bottomAnchor.constraint(equalTo: tableViewHeaderView.bottomAnchor),
            townListTitleAndSafeScoreView.leadingAnchor.constraint(equalTo: tableViewHeaderView.leadingAnchor),
            townListTitleAndSafeScoreView.trailingAnchor.constraint(equalTo: tableViewHeaderView.trailingAnchor),
        ])
        
        townListTitleAndSafeScoreView.layoutMargins = UIEdgeInsets(top: 20, left: 16, bottom: 10, right: 16)
        townListTitleAndSafeScoreView.isLayoutMarginsRelativeArrangement = true
        
        NSLayoutConstraint.activate([
            townTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            townTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            townTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            townTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        tableViewHeaderView.layoutIfNeeded()
    }
    
    override func setupView() {
        townListImageView.image = UIImage(named: "townList")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: homeLogo)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchButton)
        
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
        
        townListTitleAndSafeScoreView.backgroundColor = FindTownColor.back2.color
        
        townTableView.rowHeight = 150
        townTableView.estimatedRowHeight = 150
    }
    
    override func bindViewModel() {
        
        filterCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        //        viewModel?.input.nextPageTrigger.onNext(())
        
        //        townTableView.rx.reachedBottom(offset: 60)
        //            .bind {
        //                self.viewModel?.input.nextPageTrigger.onNext(())
        //            }
        //            .disposed(by: disposeBag)
        
        // Input
        
        searchButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                self?.viewModel?.input.searchButtonTrigger.onNext(())
            }
            .disposed(by: disposeBag)
        
        filterButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                self?.viewModel?.input.filterButtonTrigger.onNext(.Filter)
            }
            .disposed(by: disposeBag)
        
        filterResetButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                self?.viewModel?.input.resetButtonTrigger.onNext(())
                self?.FilterResetButtonHidden(true)
            }
            .disposed(by: disposeBag)
        
        filterCollectionView.rx.itemSelected
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                if $0.row == 0 { // 인프라
                    self?.viewModel?.input.filterButtonTrigger.onNext(.Infra)
                } else { // 교통
                    self?.viewModel?.input.filterButtonTrigger.onNext(.Traffic)
                }
            }
            .disposed(by: disposeBag)
        
        // Output
        
        viewModel?.output.searchFilterStringDataSource
            .observe(on: MainScheduler.instance)
            .bind(to: filterCollectionView.rx.items(
                cellIdentifier: FillterCollectionViewCell.reuseIdentifier,
                cellType: FillterCollectionViewCell.self)) { index, item, cell in
                    
                    cell.setupCell(item, index)
                    
                }.disposed(by: disposeBag)
        
        viewModel?.output.searchTownTableDataSource
            .asDriver(onErrorJustReturn: [])
            .drive(townTableView.rx.items(
                cellIdentifier: TownTableViewCell.reuseIdentifier,
                cellType: TownTableViewCell.self)) { index, item, cell in
                    
                    cell.setupCell(item)
                    cell.delegate = self
                    
                }.disposed(by: disposeBag)
        
        viewModel?.output.searchTownTableDataSource
            .asDriver(onErrorJustReturn: [])
            .drive { [weak self] searchTown in
                self?.townCountTitle.text = "\(searchTown.count)개 동네"
            }
            .disposed(by: disposeBag)
    }
    
    func dismissBottomSheet(_ filterModel: FilterModel) {
        
        FilterResetButtonHidden(false)
        
        var traffic = "교통"
        if let first = filterModel.traffic.first {
            traffic = filterModel.traffic.count == 1 ? first : first + " 외 \(filterModel.traffic.count - 1) 건"
        }
        
        let infra = filterModel.infra == "" ? "인프라" : filterModel.infra
        
        viewModel?.output.searchFilterStringDataSource.accept([infra, traffic])
        viewModel?.output.searchFilterModelDataSource.accept(filterModel)
    }
    
    private func FilterResetButtonHidden(_ isHidden: Bool) {
        if isHidden {
            townListImageView.image = UIImage(named: "townList")
            townRecommendationTitle.text = "동네 리스트"
        } else {
            townListImageView.image = UIImage(named: "townList_searched")
            townRecommendationTitle.text = "필터로 찾은 동네"
        }
        
        filterResetButton.isHidden = isHidden
        filterButton.isHidden = !isHidden
    }
}

extension HomeViewController: TownTableViewCellDelegate {
    func didTapGoToMapButton() {
        print("didTapGoToMapButton")
    }
    
    func didTapGoToIntroduceButton() {
        print("didTapGoToIntroduceButton")
    }
    
    func didTapFavoriteButton() {
        print("didTapFavoriteButton")
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath)
    -> CGSize {
        if let filter = viewModel?.output.searchFilterStringDataSource.value[indexPath.row] {
            return CGSize(width: filter.size(
                withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]
            ).width + 40, height: 40)
        }
        return CGSize(width: 100, height: 40)
    }
}

extension Reactive where Base: UIScrollView {
    func reachedBottom(offset: CGFloat = 0.0) -> ControlEvent<Void> {
        let source = contentOffset.map { contentOffset in
            let visibleHeight = self.base.frame.height - self.base.contentInset.top - self.base.contentInset.bottom
            let y = contentOffset.y + self.base.contentInset.top
            let threshold = max(offset, self.base.contentSize.height - visibleHeight)
            return y >= threshold
        }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in () }
        return ControlEvent(events: source)
    }
}
