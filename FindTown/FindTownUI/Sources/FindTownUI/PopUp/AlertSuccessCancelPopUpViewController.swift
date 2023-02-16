//
//  File.swift
//  
//
//  Created by 김성훈 on 2023/02/01.
//

import UIKit

/// 텍스트와 2개의 버튼으로 구성된 알림 팝업
public class AlertSuccessCancelPopUpViewController: UIViewController {
    
    private var titleText: String = ""
    private var messageText: String = ""
    private var successButtonText: String = ""
    private var cancelButtonText: String = ""
    
    private var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = FindTownColor.white.color
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: FindTownLabel = {
        let label = FindTownLabel(text: titleText,
                                  font: .subtitle4,
                                  textColor: .black,
                                  textAlignment: .center)
        return label
    }()
    
    private lazy var messageLabel: FindTownLabel = {
        let label = FindTownLabel(text: messageText,
                                  font: .body1,
                                  textColor: .black,
                                  textAlignment: .center)
        label.numberOfLines = 0
        let attrString = NSMutableAttributedString(string: label.text ?? "")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                value: paragraphStyle,
                                range: NSMakeRange(0, attrString.length))
        label.attributedText = attrString
        label.textAlignment = .center
        return label
    }()
    
    private lazy var successButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = FindTownFont.body3.font
        button.setTitle(successButtonText, for: .normal)
        button.setTitleColor(FindTownColor.primary.color, for: .normal)
        button.addBorder(to: .top, in: FindTownColor.grey3.color, width: 1.0)
        button.addBorder(to: .left, in: FindTownColor.grey3.color, width: 0.5)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = FindTownFont.body3.font
        button.setTitle(cancelButtonText, for: .normal)
        button.setTitleColor(FindTownColor.grey5.color, for: .normal)
        button.addBorder(to: .top, in: FindTownColor.grey3.color, width: 1.0)
        button.addBorder(to: .right, in: FindTownColor.grey3.color, width: 0.5)
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    public convenience init(titleText: String,
                            messageText: String,
                            successButtonText: String,
                            cancelButtonText: String,
                            successButtonAction: (() -> Void)? = nil,
                            cancelButtonAction: (() -> Void)? = nil) {
        
        self.init()
        
        self.titleText = titleText
        self.messageText = messageText
        self.successButtonText = successButtonText
        self.cancelButtonText = cancelButtonText
        self.successButton.addAction(for: .touchUpInside) { _ in
            self.dismiss(animated: false) {
                successButtonAction?()
            }
        }
        self.cancelButton.addAction(for: .touchUpInside) { _ in
            cancelButtonAction?()
        }
        
        /// present 시 fullScreen (화면 덮도록)
        modalPresentationStyle = .overFullScreen
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = FindTownColor.dim70.color
        setLayout()
    }
}

private extension AlertSuccessCancelPopUpViewController {
    
    func setLayout() {
        
        self.view.addSubview(contentView)
        
        [cancelButton, successButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        [titleLabel, messageLabel, buttonStackView].forEach {
            self.contentView.addSubview($0)
        }
        
        let view = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48.0),
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24.0),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 28.0),
            messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            messageLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            buttonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            buttonStackView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 24),
            buttonStackView.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}
