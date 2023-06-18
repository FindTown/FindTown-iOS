//
//  ChangeNicknameViewController.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/01.
//

import UIKit

import FindTownCore
import FindTownUI
import RxCocoa
import RxSwift

final class ChangeNicknameViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let viewModel: ChangeNicknameViewModel?
    private var keyHeight: CGFloat?
    
    // MARK: - Views
    
    private let inputNickNameTitle = FindTownLabel(text: "닉네임을 입력해주세요", font: .subtitle4)
    private let nickNameTextField = FindTownTextField()
    private let duplicateButton = FTButton(style: .mediumTintedWithRadius)
    private let nickNameTextStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    private let nickNameStatusLabel = FindTownLabel(text: "", font: .label3)
    
    private let confirmButton = FTButton(style: .largeFilled)
    
    // MARK: - Life Cycle
    
    init(viewModel: ChangeNicknameViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NSLayoutConstraint.activate([
            confirmButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -16),
            confirmButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            confirmButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }

    
    // MARK: - Functions
    
    override func addView() {
        
        nickNameTextStackView.addArrangedSubview(nickNameTextField)
        nickNameTextStackView.addArrangedSubview(duplicateButton)
        
        [inputNickNameTitle, nickNameTextStackView, nickNameStatusLabel, confirmButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        
        NSLayoutConstraint.activate([
            inputNickNameTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            inputNickNameTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
        
        NSLayoutConstraint.activate([
            nickNameTextStackView.topAnchor.constraint(equalTo: inputNickNameTitle.bottomAnchor, constant: 16),
            nickNameTextStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nickNameTextStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            duplicateButton.widthAnchor.constraint(equalToConstant: 74),
            duplicateButton.heightAnchor.constraint(equalToConstant: 44),
        ])
        
        NSLayoutConstraint.activate([
            nickNameStatusLabel.topAnchor.constraint(equalTo: nickNameTextStackView.bottomAnchor, constant: 8),
            nickNameStatusLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            confirmButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            confirmButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    override func setupView() {
        view.backgroundColor = .white
        self.title = "닉네임 수정"
        
        nickNameTextField.delegate = self
        nickNameTextField.placeholder = "공백 포함 최대 10자, 특수문자 제외"
        
        nickNameStatusLabel.isHidden = true
        
        duplicateButton.setTitle("중복확인", for: .normal)
        duplicateButton.changesSelectionAsPrimaryAction = false
        duplicateButton.isSelected = true
        
        confirmButton.setTitle("확인", for: .normal)
        confirmButton.changesSelectionAsPrimaryAction = false
        confirmButton.isEnabledAndSelected(false)
    }
    
    override func bindViewModel() {
        
        // input
        
        nickNameTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .bind { [weak self] nickname in
                self?.viewModel?.input.nickname.onNext(nickname)
            }
            .disposed(by: disposeBag)
        
        duplicateButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                self?.view.endEditing(true)
                guard let nickName = self?.nickNameTextField.text else { return }
                self?.viewModel?.input.nickNameCheckTrigger.onNext(nickName)
            }
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                self?.viewModel?.input.confirmButtonTrigger.onNext(())
            }
            .disposed(by: disposeBag)
        
        // output
        
        viewModel?.output.nickNameStatus
            .asDriver(onErrorJustReturn: .none)
            .drive { [weak self] nickNameStatus in
                self?.nickNameStatusChange(nickNameStatus)
            }
            .disposed(by: disposeBag)
        
        viewModel?.output.successNotice
            .subscribe(onNext: { [weak self] nickname in
                self?.showErrorNoticeAlertPopUp(message: "닉네임이 변경됐습니다.",
                                                buttonText: "확인",
                                                buttonAction: {
                    self?.dismiss(animated: false) {
                        self?.navigationController?.popViewController(animated: true)
                        self?.viewModel?.fetchNickname(nickname: nickname)
                    }})
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
    
    private func nickNameStatusChange(_ nickNameStatus: NicknameStatus) {
        switch nickNameStatus {
        case .none:
            nickNameStatusLabel.isHidden = true
            buttonStatusChange(true)
        case .duplicate:
            nickNameStatusLabel.text = "이미 사용한 닉네임입니다."
            nickNameStatusLabel.textColor = FindTownColor.error.color
            nickNameStatusLabel.isHidden = false
            buttonStatusChange(true)
        case .complete:
            nickNameStatusLabel.text = "사용할 수 있는 닉네임입니다."
            nickNameStatusLabel.textColor = FindTownColor.success.color
            nickNameStatusLabel.isHidden = false
            buttonStatusChange(false)
        case .includeSpecialChar:
            nickNameStatusLabel.text = "특수문자는 입력할 수 없습니다."
            nickNameStatusLabel.textColor = FindTownColor.error.color
            nickNameStatusLabel.isHidden = false
            buttonStatusChange(true)
        }
    }
    
    private func buttonStatusChange(_ isStatus: Bool) {
        duplicateButton.isEnabledAndSelected(isStatus)
        confirmButton.isEnabledAndSelected(!isStatus)
    }
}

extension ChangeNicknameViewController: UITextFieldDelegate {
    // 닉네임 글자 수 10글자로 제한
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 10
    }
}
