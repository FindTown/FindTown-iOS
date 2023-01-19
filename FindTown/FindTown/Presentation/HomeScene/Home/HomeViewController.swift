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
    private let searchIcon: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "search"), for: .normal)
        return button
    }()
    private let logoSearchStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
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
    
    private let backView = UIView()
    
    private let townRecommendationTitle = FindTownLabel(text: "동네 리스트", font: .subtitle2, textColor: .grey6)
    private let townCountTitle = FindTownLabel(text: "", font: .label1, textColor: .grey6)
    private let townListAndCountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
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
        
        [tempLogo, searchIcon].forEach {
            logoSearchStackView.addArrangedSubview($0)
        }
        
        [filterResetButton, filterButton, filterCollectionView].forEach {
            filterStackView.addArrangedSubview($0)
        }
        
        [townRecommendationTitle, townCountTitle].forEach {
            townListAndCountStackView.addArrangedSubview($0)
        }
        
        [checkBox, safetyTitle, infoIcon].forEach {
            safetyScoreStackView.addArrangedSubview($0)
        }
        
        [townListAndCountStackView, safetyScoreStackView, townTableView].forEach {
            backView.addSubview($0)
        }
        
        [logoSearchStackView, dongSearchTitle, filterStackView, backView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        NSLayoutConstraint.activate([
            logoSearchStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22),
            logoSearchStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logoSearchStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            dongSearchTitle.topAnchor.constraint(equalTo: logoSearchStackView.bottomAnchor, constant: 56),
            dongSearchTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dongSearchTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            filterStackView.topAnchor.constraint(equalTo: dongSearchTitle.bottomAnchor, constant: 16),
            filterStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        backView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: filterStackView.bottomAnchor, constant: 72),
            backView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            townListAndCountStackView.topAnchor.constraint(equalTo: backView.topAnchor, constant: 24),
            townListAndCountStackView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 16),
            townListAndCountStackView.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            safetyScoreStackView.topAnchor.constraint(equalTo: townRecommendationTitle.bottomAnchor, constant: 16),
            safetyScoreStackView.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            townTableView.topAnchor.constraint(equalTo: safetyScoreStackView.bottomAnchor, constant: 16),
            townTableView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 16),
            townTableView.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -16),
            townTableView.bottomAnchor.constraint(equalTo: backView.bottomAnchor)
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
        
        backView.backgroundColor = FindTownColor.back2.color
        
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
            .bind(to: filterCollectionView.rx.items) { collectionView, row, item in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: FillterCollectionViewCell.reuseIdentifier,
                    for: IndexPath(row: row, section: 0)
                ) as! FillterCollectionViewCell
                
                cell.setupCell(item, row)
                
                return cell
            }
            .disposed(by: disposeBag)
        
        viewModel?.output.searchTownTableDataSource
            .observe(on: MainScheduler.instance)
            .bind(to: townTableView.rx.items) { tableView, row, item in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: TownTableViewCell.reuseIdentifier,
                    for: IndexPath(row: row, section: 0)
                ) as! TownTableViewCell
                
                cell.setupCell(item)
                cell.selectionStyle = .none
                
                return cell
            }
            .disposed(by: disposeBag)
        
        viewModel?.output.searchTownTableDataSource
            .observe(on: MainScheduler.instance)
            .bind { [weak self] in
                self?.townCountTitle.text = "\($0.count)개 동네"
            }
            .disposed(by: disposeBag)
    }
    
    func dismissBottomSheet(_ tempModel: TempFilterModel) {
        
        FilterResetButtonHidden(false)
        
        let tempTrafiice = tempModel.traffic.isEmpty ? "교통" :
        tempModel.traffic.count == 1 ? tempModel.traffic.first :
        "\(tempModel.traffic.first ?? "") 외 \(tempModel.traffic.count-1)개"
        guard let tempTrafiice else { return }
        
        let tempInfra = tempModel.infra == "" ? "인프라" : tempModel.infra
        
        viewModel?.output.searchFilterDataSource.accept([tempInfra, tempTrafiice])
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
