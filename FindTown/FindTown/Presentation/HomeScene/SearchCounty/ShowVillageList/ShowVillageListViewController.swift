//
//  GuSelectDongViewController.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/24.
//

import UIKit

import FindTownUI
import FindTownCore
import RxCocoa
import RxSwift

final class ShowVillageListViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let viewModel: ShowVillageListViewModel?
    
    // MARK: - Views
    
    private let topEmptyView = UIView()
    
    private let selectCountyTitle = FindTownLabel(text: "", font: .subtitle5)
    private let townCountTitle = FindTownLabel(text: "", font: .label1, textColor: .grey6)
    private let townListAndCountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
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
    
    init(viewModel: ShowVillageListViewModel?) {
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
        
        [selectCountyTitle, townCountTitle].forEach {
            townListAndCountStackView.addArrangedSubview($0)
        }
        
        [townTableView].forEach {
            townListBackgroundView.addArrangedSubview($0)
        }
        
        [topEmptyView, townListAndCountStackView, townListBackgroundView].forEach {
            self.stackView.addArrangedSubview($0)
        }
    }
    
    override func setLayout() {
        super.setLayout()
        
        stackView.setCustomSpacing(24, after: topEmptyView)
        stackView.setCustomSpacing(16, after: townListAndCountStackView)
        
        townListBackgroundView.layoutMargins = UIEdgeInsets(top: 24, left: 0, bottom: 16, right: 0)
        townListBackgroundView.isLayoutMarginsRelativeArrangement = true
        
        [townListAndCountStackView].forEach {
            $0.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            $0.isLayoutMarginsRelativeArrangement = true
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        NSLayoutConstraint.activate([
            townTableView.heightAnchor.constraint(equalToConstant: townTableView.contentSize.height),
        ])
    }
    
    override func setupView() {
        view.backgroundColor = FindTownColor.white.color
        townListBackgroundView.backgroundColor = FindTownColor.back2.color
        
        guard let selectCountyData = self.viewModel?.selectCountyData else { return }
        selectCountyTitle.text = "서울시 \(selectCountyData)"
        
        townTableView.rowHeight = 150
        townTableView.estimatedRowHeight = 150
    }
    
    override func bindViewModel() {
        
        // Input
        
        // Output
        
        viewModel?.output.searchTownTableDataSource
            .observe(on: MainScheduler.instance)
            .bind(to: townTableView.rx.items(
                cellIdentifier: TownTableViewCell.reuseIdentifier,
                cellType: TownTableViewCell.self)) { index, item, cell in
                    
                    cell.setupCell(item)
                    cell.delegate = self
                    
                }.disposed(by: disposeBag)
        
        viewModel?.output.searchTownTableDataSource
            .observe(on: MainScheduler.instance)
            .bind { [weak self] searchTown in
                self?.townCountTitle.text = "\(searchTown.count)개 동네"
            }
            .disposed(by: disposeBag)
    }
}

extension ShowVillageListViewController: TownTableViewCellDelegate {
    func didTapGoToMapButton() {
        print("didTapGoToMapButton")
    }
    
    func didTapGoToIntroduceButton() {
        print("didTapGoToIntroduceButton")
    }
    
    func didTapHeartButton() {
        print("didTapHeartButton")
    }
}
