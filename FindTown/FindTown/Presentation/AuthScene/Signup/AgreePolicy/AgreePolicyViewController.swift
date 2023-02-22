//
//  AgreePolicyViewController.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/09.
//

import UIKit

import FindTownUI
import FindTownCore
import RxCocoa
import RxSwift

final class AgreePolicyViewController: BaseBottomSheetViewController {
    
    // MARK: - Properties
    
    private let viewModel: AgreePolicyViewModel?
    private let bottomHeight: CGFloat
    
    // MARK: - Views
    
    private let agreePolicyTitle = FindTownLabel(text: "이용약관에 동의가 필요해요", font: .subtitle4)
    
    fileprivate let allAgreeCheckButton = CheckButton()
    private let allAgreeTitle = FindTownLabel(text: "모두 동의", font: .body3)
    private let allAgreeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    fileprivate let agreePolicyCheckButton = CheckButton()
    private let agreePolicyLabel = FindTownLabel(text: "이용약관 필수", font: .body3)
    private let agreePolicyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    private let agreePolicyViewButton: UIButton = {
        var button = UIButton()
        button.setTitle("보기", for: .normal)
        button.setTitleColor(FindTownColor.grey5.color, for: .normal)
        button.setUnderline()
        button.titleLabel?.font = FindTownFont.label2.font
        button.backgroundColor = .clear
        return button
    }()
    
    fileprivate let agreePersonalInfoCheckButton = CheckButton()
    private let agreePersonalInfoLabel = FindTownLabel(text: "개인정보 수집 이용 동의", font: .body3)
    private let agreePersonalInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    private let agreePersonalInfoViewButton: UIButton = {
        var button = UIButton()
        button.setTitle("보기", for: .normal)
        button.setTitleColor(FindTownColor.grey5.color, for: .normal)
        button.setUnderline()
        button.titleLabel?.font = FindTownFont.label2.font
        button.backgroundColor = .clear
        return button
    }()
    
    private let confirmButton = FTButton(style: .largeFilled)
    
    // MARK: - Life Cycle
    
    init(viewModel: AgreePolicyViewModel, bottomHeight: CGFloat = 360) {
        self.viewModel = viewModel
        self.bottomHeight = bottomHeight
        super.init(bottomHeight: bottomHeight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Functions
    
    override func addView() {
        allAgreeStackView.addArrangedSubview(allAgreeCheckButton)
        allAgreeStackView.addArrangedSubview(allAgreeTitle)
        
        agreePolicyStackView.addArrangedSubview(agreePolicyCheckButton)
        agreePolicyStackView.addArrangedSubview(agreePolicyLabel)
        agreePolicyStackView.addArrangedSubview(agreePolicyViewButton)
        
        agreePersonalInfoStackView.addArrangedSubview(agreePersonalInfoCheckButton)
        agreePersonalInfoStackView.addArrangedSubview(agreePersonalInfoLabel)
        agreePersonalInfoStackView.addArrangedSubview(agreePersonalInfoViewButton)
        
        [agreePolicyTitle, allAgreeStackView, agreePolicyStackView, agreePersonalInfoStackView, confirmButton].forEach {
            bottomSheetView.addSubview($0)
        }
        super.addView()
    }
    
    override func setLayout() {
        NSLayoutConstraint.activate([
            agreePolicyTitle.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 40),
            agreePolicyTitle.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 16),
        ])
        
        NSLayoutConstraint.activate([
            allAgreeStackView.topAnchor.constraint(equalTo: agreePolicyTitle.bottomAnchor, constant: 34),
            allAgreeStackView.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 18),
        ])
        
        NSLayoutConstraint.activate([
            agreePolicyStackView.topAnchor.constraint(equalTo: allAgreeStackView.bottomAnchor, constant: 16),
            agreePolicyStackView.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 18),
            agreePolicyStackView.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            agreePersonalInfoStackView.topAnchor.constraint(equalTo: agreePolicyStackView.bottomAnchor, constant: 16),
            agreePersonalInfoStackView.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 18),
            agreePersonalInfoStackView.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            confirmButton.bottomAnchor.constraint(equalTo: bottomSheetView.bottomAnchor, constant: -40),
            confirmButton.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 16),
            confirmButton.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor, constant: -16),
        ])
        
        allAgreeCheckButton.setContentHuggingPriority(.required, for: .horizontal)
        agreePolicyCheckButton.setContentHuggingPriority(.required, for: .horizontal)
        agreePersonalInfoCheckButton.setContentHuggingPriority(.required, for: .horizontal)
        agreePolicyLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        agreePersonalInfoLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        super.setLayout()
    }
    
    override func setupView() {
        super.setupView()
        
        bottomSheetView.backgroundColor = .white
        
        confirmButton.setTitle("확인", for: .normal)
        confirmButton.changesSelectionAsPrimaryAction = false
        confirmButton.isSelected = false
        confirmButton.isEnabled = false
    }
    
    override func bindViewModel() {
        
        // Input
        
        allAgreeCheckButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                guard let isSeleted = self?.allAgreeCheckButton.isSelected else { return }
                self?.viewModel?.input.allAgree.onNext((isSeleted))
            }
            .disposed(by: disposeBag)
        
        agreePolicyCheckButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                guard let isSeleted = self?.agreePolicyCheckButton.isSelected else { return }
                self?.viewModel?.input.policy.onNext((isSeleted))
            }
            .disposed(by: disposeBag)
        
        agreePolicyViewButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { _ in
                if let url = URL(string: "https://yapp-workspace.notion.site/fec4a724526e4c11b5aea79884b9c966") {
                    UIApplication.shared.open(url)
                }
            }
            .disposed(by: disposeBag)
        
        agreePersonalInfoCheckButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                guard let isSeleted = self?.agreePersonalInfoCheckButton.isSelected else { return }
                self?.viewModel?.input.personalInfo.onNext((isSeleted))
            }
            .disposed(by: disposeBag)
        
        agreePersonalInfoViewButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { _ in
                if let url = URL(string: "https://yapp-workspace.notion.site/577e8340762440dd97ccb5ee16a57f8e") {
                    UIApplication.shared.open(url)
                }
            }
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                self?.setBottomSheetStatus(to: .hide)
                self?.viewModel?.input.confirmButtonTrigger.onNext(())
            }
            .disposed(by: disposeBag)
        
        // Output
        
        viewModel?.output.buttonsSelected
            .asDriver(onErrorJustReturn: false)
            .drive(self.rx.buttonIsSelected)
            .disposed(by: disposeBag)
        
        viewModel?.output.confirmButtonEnabled
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive {
                self.confirmButton.isSelected = $0
                self.confirmButton.isEnabled = $0
                self.allAgreeCheckButton.isSelected = $0
            }
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: AgreePolicyViewController {
    
    var buttonIsSelected: Binder<Bool> {
        return Binder(self.base) { view, isSeleted in
            view.allAgreeCheckButton.isSelected = isSeleted
            view.agreePolicyCheckButton.isSelected = isSeleted
            view.agreePersonalInfoCheckButton.isSelected = isSeleted
        }
    }
}
