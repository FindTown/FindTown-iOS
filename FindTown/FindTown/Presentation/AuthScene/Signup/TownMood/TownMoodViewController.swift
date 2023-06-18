//
//  SignUpSecondViewController.swift
//  FindTown
//
//  Created by 김성훈 on 2022/12/31.
//

import UIKit

import FindTownCore
import FindTownUI
import RxCocoa
import RxSwift

final class TownMoodViewController: BaseViewController {
    
    // MARK: - Properteis
    
    private let viewModel: TownMoodViewModel?
    private var keyHeight: CGFloat?
    private let textViewPlaceHolder = "동네의 장, 단점 or 동네 생활 꿀팁을 알려주세요. \n(최소 10자 이상 작성)"
    private let afterTwentyTitleText = "최소 10자 이상 작성해주세요"
    
    // MARK: - Views
    
    private let nowStatusPogressView = UIProgressView(progressViewStyle: .bar)
    
    private let townLikeTitle = FindTownLabel(text: "살고 있는 동네는 어떤가요?", font: .subtitle4)
    
    private let townLikeTextView: UITextView = {
        let textField = UITextView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let afterTwentyTitle = FindTownLabel(text: "", font: .label3, textColor: .error)
    
    private let textViewCountTitle = FindTownLabel(text: "0/100", font: .label3)
    
    private let textViewGuideTitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let nextButton = FTButton(style: .largeFilled)
    
    // MARK: - Life Cycle
    
    init(viewModel: TownMoodViewModel) {
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
            nextButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -16),
            nextButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nextButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    // MARK: - Functions
    
    override func addView() {
        textViewGuideTitleStackView.addArrangedSubview(afterTwentyTitle)
        textViewGuideTitleStackView.addArrangedSubview(textViewCountTitle)
        
        [nowStatusPogressView, townLikeTitle, townLikeTextView,
         textViewGuideTitleStackView, nextButton].forEach {
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
            townLikeTitle.topAnchor.constraint(equalTo: nowStatusPogressView.bottomAnchor, constant: 48),
            townLikeTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
        
        NSLayoutConstraint.activate([
            townLikeTextView.topAnchor.constraint(equalTo: townLikeTitle.bottomAnchor,constant: 16),
            townLikeTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            townLikeTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            townLikeTextView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            textViewGuideTitleStackView.topAnchor.constraint(equalTo: townLikeTextView.bottomAnchor, constant: 8),
            textViewGuideTitleStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textViewGuideTitleStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -16),
            nextButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nextButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    override func setupView() {
        
        view.backgroundColor = .white
        
        nowStatusPogressView.trackTintColor = FindTownColor.grey2.color
        nowStatusPogressView.progressTintColor = FindTownColor.primary.color
        nowStatusPogressView.progress = Float(3) / 5.0
        
        townLikeTextView.delegate = self
        townLikeTextView.text = textViewPlaceHolder
        townLikeTextView.textColor = FindTownColor.grey5.color
        townLikeTextView.tintColor = FindTownColor.primary.color
        townLikeTextView.textContainerInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16);
        townLikeTextView.font = FindTownFont.label1.font
        
        townLikeTextView.layer.cornerRadius = 8.0
        townLikeTextView.layer.borderWidth = 1.0
        townLikeTextView.layer.borderColor = FindTownColor.grey4.color.cgColor
        
        nextButton.setTitle("다음", for: .normal)
        nextButton.changesSelectionAsPrimaryAction = false
        nextButton.isSelected = false
        nextButton.isEnabled = false
    }
    
    override func bindViewModel() {
        
        // Input
        
        townLikeTextView.rx.text.orEmpty
            .distinctUntilChanged()
            .bind { [weak self] inputText in
                if inputText != self?.textViewPlaceHolder {
                    self?.viewModel?.input.townLikeText.onNext(inputText)
                    
                }
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind { [weak self] in
                self?.view.endEditing(true)
                self?.viewModel?.input.nextButtonTrigger.onNext(())
            }
            .disposed(by: disposeBag)
        
        // Output
        
        viewModel?.output.buttonsSelected
            .asDriver(onErrorJustReturn: false)
            .drive { [weak self] isSelected in
                self?.buttonIsSelectedChange(isSelected)
            }
            .disposed(by: disposeBag)
    }
    
    private func buttonIsSelectedChange(_ isSelected: Bool) {
        if isSelected != nextButton.isSelected {
            nextButton.isSelected = isSelected
            nextButton.isEnabled = isSelected
        }
        afterTwentyTitle.text = isSelected ? "" : afterTwentyTitleText
    }
}

extension TownMoodViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let textViewText = textView.text else { return false }
        let currentText = textViewText
        guard let stringRange = Range(range, in: currentText) else { return false }
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        textViewCountTitle.text = "\(changedText.count)/100"
        
        return changedText.count < 100
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == FindTownColor.grey5.color {
            textView.text = nil
            textView.textColor = FindTownColor.grey7.color
            textView.layer.borderColor = FindTownColor.grey6.color.cgColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = FindTownColor.grey5.color
            textView.layer.borderColor = FindTownColor.grey4.color.cgColor
        }
    }
}
