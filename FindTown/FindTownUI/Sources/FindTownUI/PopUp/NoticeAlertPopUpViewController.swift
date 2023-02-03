//
//  File.swift
//  
//
//  Created by 이호영 on 2023/02/03.
//

import UIKit

public enum PopupStatus {
    case show, dismiss
}

public class NoticeAlertPopUpViewController: UIViewController {

    private var titleText: String = ""
    private var messageText: String = ""
    private var confirmButtonText: String = ""

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

    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = FindTownFont.body3.font
        button.setTitle(confirmButtonText, for: .normal)
        button.setTitleColor(FindTownColor.primary.color, for: .normal)
//        button.addBorder(to: .top, in: FindTownColor.grey3.color, width: 1.0)
//        button.addBorder(to: .left, in: FindTownColor.grey3.color, width: 0.5)
        return button
    }()

    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    public lazy var dimmedBackView: UIView = {
        let view = UIView()
        view.backgroundColor = FindTownColor.dim70.color
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.0
        return view
    }()

    public convenience init(titleText: String,
                            messageText: String,
                            confirmButtonText: String,
                            confirmButtonAction: (() -> Void)? = nil) {

        self.init()

        self.titleText = titleText
        self.messageText = messageText
        self.confirmButtonText = confirmButtonText
        self.confirmButton.addAction(for: .touchUpInside) { _ in
            if let confirmButtonAction = confirmButtonAction {
                confirmButtonAction()
            } else {
                self.setBottomSheetStatus(to: .dismiss)
            }
        }

        /// present 시 fullScreen (화면 덮도록)
        modalPresentationStyle = .overFullScreen
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setBottomSheetStatus(to: .show)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .clear
        setLayout()
    }
    
    public func setBottomSheetStatus(to status: PopupStatus) {
        switch status {
        case .show:
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
                self.dimmedBackView.alpha = 0.5
                self.view.layoutIfNeeded()
                
            }, completion: nil)
        case .dismiss:
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
                self.dismiss(animated: false, completion: nil)
            })
        }
    }
}

private extension NoticeAlertPopUpViewController {

    func setLayout() {

        self.view.addSubview(dimmedBackView)
        self.view.addSubview(contentView)

        [confirmButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }

        [titleLabel, messageLabel, buttonStackView].forEach {
            self.contentView.addSubview($0)
        }

        let view = self.view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            dimmedBackView.topAnchor.constraint(equalTo: self.view.topAnchor),
            dimmedBackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedBackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmedBackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
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
