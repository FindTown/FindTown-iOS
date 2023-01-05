//
//  SignUpNickNameViewController.swift
//  FindTown
//
//  Created by 김성훈 on 2022/12/29.
//

import UIKit

import FindTownCore
import FindTownUI
import RxCocoa
import RxSwift

final class NicknameViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let viewModel: NicknameViewModel?
    
    // MARK: - Views
    
    private let nowStatusPogressView = UIProgressView(progressViewStyle: .bar)
    
    private let inputNickNameTitle = FindTownLabel(text: "닉네임을 입력해주세요", font: .subtitle4)
    
    private let nickNameTextField = FindTownTextField()
    
    private let nickNameStatusLabel = FindTownLabel(text: "", font: .label3, textColor: .semantic)
    
    private let duplicateButton = FTButton(style: .mediumTintedWithRadius)
    
    private let nextButton = FTButton(style: .largeFilled)
    
    // MARK: - Life Cycle
    
    init(viewModel: NicknameViewModel) {
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
        [nowStatusPogressView, inputNickNameTitle, nickNameTextField,
         nickNameStatusLabel, duplicateButton, nextButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        nowStatusPogressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nowStatusPogressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nowStatusPogressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nowStatusPogressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nowStatusPogressView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            inputNickNameTitle.topAnchor.constraint(equalTo: nowStatusPogressView.bottomAnchor, constant: 74),
            inputNickNameTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            nickNameTextField.topAnchor.constraint(equalTo: inputNickNameTitle.bottomAnchor, constant: 16),
            nickNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nickNameTextField.trailingAnchor.constraint(equalTo: duplicateButton.leadingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            nickNameStatusLabel.topAnchor.constraint(equalTo: nickNameTextField.bottomAnchor, constant: 8),
            nickNameStatusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
        
        NSLayoutConstraint.activate([
            duplicateButton.topAnchor.constraint(equalTo: inputNickNameTitle.bottomAnchor, constant: 16),
            duplicateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            duplicateButton.widthAnchor.constraint(equalToConstant: 74),
            duplicateButton.heightAnchor.constraint(equalToConstant: 44),
        ])
        
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    override func setupView() {
        view.backgroundColor = .white
        
        nowStatusPogressView.trackTintColor = FindTownColor.grey2.color
        nowStatusPogressView.progressTintColor = FindTownColor.primary.color
        nowStatusPogressView.progress = Float(1) / 4.0
        
        nickNameTextField.delegate = self
        nickNameTextField.placeholder = "공백 포함 최대 10자, 특수문자 제외"
        
        nickNameStatusLabel.isHidden = true
        
        duplicateButton.setTitle("중복확인", for: .normal)
        duplicateButton.changesSelectionAsPrimaryAction = false
        duplicateButton.isSelected = true
        
        nextButton.setTitle("다음", for: .normal)
        nextButton.changesSelectionAsPrimaryAction = false
        nextButton.isSelected = false
    }
    
    override func bindViewModel() {
        
        // input
        
        nickNameTextField.rx.text.orEmpty
            .bind { [weak self] in
                self?.viewModel?.input.nickname.onNext($0)
            }
            .disposed(by: disposeBag)
        
        duplicateButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                self?.viewModel?.input.nickNameCheckTrigger.onNext(self?.nickNameTextField.text ?? "")
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                if self!.nextButton.isSelected { self?.viewModel?.input.nextButtonTrigger.onNext(()) }
            }
            .disposed(by: disposeBag)
        
        // output
        
        viewModel?.output.buttonsSelected
            .asDriver(onErrorJustReturn: true)
            .drive { [weak self] in
                self?.buttonIsSelectedChange(isSelected: $0)
            }
            .disposed(by: disposeBag)
        
        viewModel?.output.nickNameStatus
            .asDriver(onErrorJustReturn: .none)
            .drive { [weak self] in
                self?.nickNameStatusChange(nickNameStatus: $0)
            }
            .disposed(by: disposeBag)
    }
    
    private func buttonIsSelectedChange(isSelected: Bool) {
        if isSelected == nextButton.isSelected {
            duplicateButton.isSelected = isSelected
            nextButton.isSelected = !isSelected
        }
    }
    
    private func nickNameStatusChange(nickNameStatus: NicknameStatus) {
        switch nickNameStatus {
        case .none:
            nickNameStatusLabel.isHidden = true
            buttonIsSelectedChange(isSelected: true)
            break
        case .duplicate:
            nickNameStatusLabel.text = "이미 사용한 닉네임입니다."
            nickNameStatusLabel.isHidden = false
            buttonIsSelectedChange(isSelected: true)
            break
        case .complete:
            nickNameStatusLabel.isHidden = true
            buttonIsSelectedChange(isSelected: false)
            break
        case .inSpecialChar:
            nickNameStatusLabel.text = "특수문자는 입력할 수 없습니다."
            nickNameStatusLabel.isHidden = false
            buttonIsSelectedChange(isSelected: true)
            break
        }
    }
}

extension NicknameViewController: UITextFieldDelegate {
    // 닉네임 글자 수 10글자로 제한
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 10
    }
}
