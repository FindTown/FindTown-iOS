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
    
    private let townCountTitle = FindTownLabel(text: "", font: .label1, textColor: .grey6)
    private let townListAndCountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let townTableView = TownTableView()

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
        [townCountTitle].forEach {
            townListAndCountStackView.addArrangedSubview($0)
        }
        
        [townListAndCountStackView, townTableView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        townListAndCountStackView.layoutMargins = UIEdgeInsets(top: 20, left: 16, bottom: 16, right: 16)
        townListAndCountStackView.isLayoutMarginsRelativeArrangement = true
        
        NSLayoutConstraint.activate([
            townListAndCountStackView.topAnchor.constraint(equalTo: view.topAnchor),
            townListAndCountStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            townListAndCountStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            townTableView.topAnchor.constraint(equalTo: townListAndCountStackView.bottomAnchor),
            townTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            townTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            townTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    override func setupView() {
        view.backgroundColor = FindTownColor.white.color
        townTableView.contentInset = UIEdgeInsets(top: 24 - 8, left: 0, bottom: 0, right: 0)
        
        guard let selectCountyData = self.viewModel?.searchData,
              self.viewModel?.searchType == .sgg else { return }
        self.title = "서울시 \(selectCountyData)"
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
                self?.townCountTitle.text = "총 \(searchTown.count)개 동네"
            }
            .disposed(by: disposeBag)
    
        viewModel?.output.isFavorite
            .subscribe(onNext: { [weak self] isFavorite in
                let toastMessage = isFavorite ? "찜 목록에 추가되었어요" : "찜 목록에서 삭제되었어요"
                self?.showToast(message: toastMessage, height: 120)
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
