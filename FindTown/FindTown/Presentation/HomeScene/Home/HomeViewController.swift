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
    
    private let indicator = UIActivityIndicatorView(style: .medium)
    
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
    
    private let safetyGuideView = UIView()
    private let safetyEmptyView = UIView()
    private let checkBox = CheckBox()
    private let safetyTitle = FindTownLabel(text: "안전 점수가 높은", font: .label1, textColor: .grey6)
    private let infoIconBackView = UIView()
    private let infoIcon = UIImageView(image: UIImage(named: "information"))
    private let safetyScoreStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    private let safetyToolTip = ToolTip(text: "안전 점수는 동네별 범죄와 생활안전\n지수의 평균을 반영한 값입니다.",
                                        viewColor: .black, textColor: .white,
                                        tipLocation: .topCustom(tipXPoint: 100.0), width: 100, height: 52)
    
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
        
        [townRecommendationTitle].forEach {
            townImageTitleStackView.addArrangedSubview($0)
        }
        
        [townImageTitleStackView, townCountTitle].forEach {
            townListAndCountStackView.addArrangedSubview($0)
        }
        
        [safetyEmptyView, safetyGuideView, checkBox, safetyTitle, infoIconBackView].forEach {
            safetyScoreStackView.addArrangedSubview($0)
        }
        
        infoIconBackView.addSubview(infoIcon)
        
        [townListAndCountStackView, safetyScoreStackView].forEach {
            townListTitleAndSafeScoreView.addArrangedSubview($0)
        }
        
        [spacingView, villageSearchTitle, filterStackView, townListTitleAndSafeScoreView, safetyToolTip].forEach {
            tableViewHeaderView.addSubview($0)
        }
        
        view.addSubview(indicator)
        view.addSubview(townTableView)
        townTableView.tableHeaderView = tableViewHeaderView
        townTableView.tableHeaderView?.backgroundColor = FindTownColor.white.color
    }
    
    override func setLayout() {
        NSLayoutConstraint.activate([
            safetyToolTip.topAnchor.constraint(equalTo: safetyScoreStackView.bottomAnchor, constant: 10.0),
            safetyToolTip.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10.0)
        ])
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.topAnchor.constraint(equalTo: view.topAnchor),
            indicator.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            indicator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            indicator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        infoIconBackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoIconBackView.widthAnchor.constraint(equalToConstant: 15),
            infoIconBackView.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        infoIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoIcon.centerXAnchor.constraint(equalTo: infoIconBackView.centerXAnchor),
            infoIcon.centerYAnchor.constraint(equalTo: infoIconBackView.centerYAnchor),
        ])
        
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
        
        safetyEmptyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            safetyEmptyView.heightAnchor.constraint(equalToConstant: 30),
            safetyEmptyView.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        tableViewHeaderView.layoutIfNeeded()
    }
    
    override func setupView() {
        indicator.startAnimating()
        
        setTownRecommendationTitle("townList", "동네 리스트")
        
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
        
        townTableView.tableFooterView?.isHidden = true
        townTableView.isHidden = true
        townTableView.rowHeight = 150
        townTableView.estimatedRowHeight = 150
        
        safetyToolTip.dismiss()
        addTapGesture()
        
        [safetyTitle, infoIconBackView].forEach {
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapSafetyTitleAndIcon))
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(tap)
        }
        
        viewModel?.fetchTownInformation()
    }
    
    override func bindViewModel() {
        
        filterCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        // Input
        
        checkBox.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                guard let isSafetyHigh = self?.checkBox.isSelected else { return }
                self?.viewModel?.input.safetySortTrigger.onNext(isSafetyHigh)
            }
            .disposed(by: disposeBag)
        
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
                self?.townTableView.backgroundColor = FindTownColor.back2.color
                self?.viewModel?.input.resetButtonTrigger.onNext(())
                self?.setupTableView(true)
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
        
        viewModel?.input.fetchFinishTrigger
            .bind { [weak self] in
                self?.indicator.stopAnimating()
                self?.indicator.isHidden = true
                self?.townTableView.isHidden = false
                self?.townTableView.backgroundColor = FindTownColor.white.color
            }
            .disposed(by: disposeBag)
        
        viewModel?.input.setEmptyViewTrigger
            .bind { [weak self] in
                self?.setupTableViewFooterView(.FilterEmptyView)
            }
            .disposed(by: disposeBag)
        
        viewModel?.input.setNetworkErrorViewTrigger
            .bind { [weak self] in
                self?.setupTableViewFooterView(.NetworkErrorView)
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
                    
                    cell.setupCell(item, cityCode: item.objectId)
                    cell.delegate = self
                    
                }.disposed(by: disposeBag)
        
        viewModel?.output.searchTownTableDataSource
            .asDriver(onErrorJustReturn: [])
            .drive { [weak self] searchTown in
                self?.townCountTitle.text = "\(searchTown.count)개 동네"
            }
            .disposed(by: disposeBag)
        
        viewModel?.output.isFavorite
            .filter { $0 == false }
            .subscribe(onNext: { [weak self] _ in
                let toastMessage = "찜 목록에서 삭제되었어요"
                self?.showToast(message: toastMessage, height: 120)
            })
            .disposed(by: disposeBag)
        
        viewModel?.output.errorNotice
            .bind { [weak self] in
                self?.showErrorNoticeAlertPopUp(message: "네트워크 오류가 발생하였습니다.",
                                                buttonText: "확인")
            }
            .disposed(by: disposeBag)
    }
    
    func dismissBottomSheet(_ filterModel: FilterModel) {
        
        setupTableView(false)
        
        var traffic = "교통"
        if let first = filterModel.traffic.first {
            traffic = filterModel.traffic.count == 1 ? first : first + " 외 \(filterModel.traffic.count - 1) 건"
        }
        
        let infra = filterModel.infra == "" ? "인프라" : filterModel.infra
        
        viewModel?.output.searchFilterStringDataSource.accept([infra, traffic])
        viewModel?.output.searchFilterModelDataSource.accept(filterModel)
        
        viewModel?.fetchTownInformation(filterStatus: filterModel.toFilterStatus, subwayList: filterModel.traffic)
    }
    
    private func setupTableView(_ isHidden: Bool) {
        townTableView.tableFooterView = nil
        setupTableViewSafetyView(false)
        if isHidden {
            setTownRecommendationTitle("townList", "동네 리스트")
        } else {
            setTownRecommendationTitle("townList_searched", "필터로 찾은 동네")
        }
        filterResetButton.isHidden = isHidden
        filterButton.isHidden = !isHidden
        checkBox.isSelected = false
    }
    
    private func setupTableViewFooterView(_ footerType: FooterType) {
        setupTableViewSafetyView(true)
        
        let townTableFooterView = TownTableFooterView()
        townTableFooterView.delegate = self
        townTableView.tableFooterView = townTableFooterView
        townTableFooterView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            townTableFooterView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200),
            townTableFooterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            townTableFooterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            townTableFooterView.heightAnchor.constraint(equalToConstant: 300),
        ])
        
        footerType == .NetworkErrorView ? townTableFooterView.setNetworkErrorView() : townTableFooterView.setFilterEmptyView()
    }
    
    private func setupTableViewSafetyView(_ isHidden: Bool) {
        if isHidden {
            townTableView.backgroundColor = FindTownColor.back2.color
        }
        townTableView.isScrollEnabled = !isHidden
        townTableView.tableFooterView?.isHidden = !isHidden
        
        checkBox.isHidden = isHidden
        safetyTitle.isHidden = isHidden
        infoIconBackView.isHidden = isHidden
    }
    
    enum FooterType {
        case NetworkErrorView
        case FilterEmptyView
    }
    
    enum TownTableType {
        case List
        case Filter
    }
}

extension HomeViewController: TownTableViewCellDelegate {
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

extension HomeViewController: TownTableFooterViewDelegate {
    func didTapRetryButton() {
        viewModel?.input.resetButtonTrigger.onNext(())
        setupTableView(true)
    }
}

extension HomeViewController: HomeFavoriteDelegate {
    func HomeFavoriteFetch(_ cityCode: Int) {
        self.viewModel?.input.favoriteButtonTrigger.onNext(cityCode)
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

private extension HomeViewController {
    
    @objc func tapSafetyTitleAndIcon() {
        if safetyToolTip.alpha == 1.0 {
            safetyToolTip.dismiss()
        } else {
            safetyToolTip.alpha = 1.0
        }
    }
    
    func addTapGesture() {
        let backViewTap = UITapGestureRecognizer(target: self, action: #selector(backViewTapped(_:)))
        backViewTap.cancelsTouchesInView = false
        view.addGestureRecognizer(backViewTap)
    }
    
    @objc func backViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        let backViewTappedLocation = tapRecognizer.location(in: self.safetyToolTip)
        if safetyToolTip.point(inside: backViewTappedLocation, with: nil) == false {
            safetyToolTip.dismiss()
        }
    }
    
    func setTownRecommendationTitle(_ imageNamed: String, _ labelText: String) {
        let attributedString = NSMutableAttributedString(string: "")
        let imageAttachment = NSTextAttachment()
        let image = UIImage(named: imageNamed)
        guard let image = image else { return }
        imageAttachment.image = image
        imageAttachment.bounds = CGRect(x: 0, y: (FindTownFont.subtitle2.font.capHeight - image.size.height) / 2, width: image.size.width, height: image.size.height)
        let padding = " "
        let paddingString = NSAttributedString(string: padding)
        attributedString.append(NSAttributedString(attachment: imageAttachment))
        attributedString.append(paddingString)
        attributedString.append(NSAttributedString(string: labelText))
        townRecommendationTitle.attributedText = attributedString
        townRecommendationTitle.sizeToFit()
    }
}
