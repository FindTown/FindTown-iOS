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
        [selectCountyTitle, townCountTitle].forEach {
            townListAndCountStackView.addArrangedSubview($0)
        }
        
        view.addSubview(townTableView)
        townTableView.tableHeaderView = townListAndCountStackView
    }
    
    override func setLayout() {
        townListAndCountStackView.layoutMargins = UIEdgeInsets(top: 20, left: 16, bottom: 10, right: 16)
        townListAndCountStackView.isLayoutMarginsRelativeArrangement = true
        
        townListAndCountStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            townListAndCountStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            townListAndCountStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            townTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            townTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            townTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            townTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    override func setupView() {
        view.backgroundColor = FindTownColor.white.color
        townListBackgroundView.backgroundColor = FindTownColor.back2.color
        
        guard let selectCountyData = self.viewModel?.selectCountyData else { return }
        selectCountyTitle.text = "서울시 \(selectCountyData)"
        
        townTableView.rowHeight = 150
        townTableView.estimatedRowHeight = 150
        
        viewModel?.fetchTownInformation()
    }
    
    override func bindViewModel() {
        
        // Input
        
        // Output
        
        viewModel?.output.searchTownTableDataSource
            .observe(on: MainScheduler.instance)
            .bind(to: townTableView.rx.items(
                cellIdentifier: TownTableViewCell.reuseIdentifier,
                cellType: TownTableViewCell.self)) { index, item, cell in
                    cell.setupCell(item, cityCode: item.objectId)
                    cell.delegate = self
                    
                }.disposed(by: disposeBag)
        
        viewModel?.output.searchTownTableDataSource
            .observe(on: MainScheduler.instance)
            .bind { [weak self] searchTown in
                self?.townCountTitle.text = "\(searchTown.count)개 동네"
            }
            .disposed(by: disposeBag)
        
        viewModel?.output.isFavorite
            .filter { $0 == false }
            .subscribe(onNext: { [weak self] _ in
                let toastMessage = "찜 목록에서 삭제되었어요"
                self?.showToast(message: toastMessage, height: 60)
            })
            .disposed(by: disposeBag)
        
        viewModel?.output.errorNotice
            .subscribe { [weak self] _ in
                self?.showErrorNoticeAlertPopUp(message: "네트워크 오류가 발생하였습니다.",
                                                buttonText: "확인",
                                                buttonAction: {
                    self?.dismiss(animated: false) {
                        self?.navigationController?.popViewController(animated: true)
                    }})
            }
            .disposed(by: disposeBag)
    }
}

extension ShowVillageListViewController: TownTableViewCellDelegate {
    
    func didTapGoToIntroduceButton(cityCode: Int) {
        self.viewModel?.input.townIntroButtonTrigger.onNext(cityCode)
    }
    
    func didTapGoToMapButton(cityCode: Int) {
        self.viewModel?.input.townMapButtonTrigger.onNext(cityCode)
    }
    
    func didTapFavoriteButton(cityCode: Int) {
        if UserDefaultsSetting.isAnonymous {
            self.showAlertSuccessCancelPopUp(title: "",
                                             message: "찜 기능은 회원가입/로그인 후\n 사용 가능해요.",
                                             successButtonText: "회원가입",
                                             cancelButtonText: "취소",
                                             successButtonAction: {
                self.viewModel?.input.goToAuthButtonTrigger.onNext(())})
        } else {
            self.viewModel?.input.favoriteButtonTrigger.onNext(cityCode)
        }
    }
}
