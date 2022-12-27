//
//  AlertPopUpViewController.swift
//  
//
//  Created by 장선영 on 2022/12/27.
//

import UIKit

public class AlertPopUpViewController: UIViewController {
    
    private var messageText: String = ""
    private var buttonText: String = ""
    
    private var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = FindTownColor.white.color
        view.layer.cornerRadius = 16
        
        /// 애니메이션
        view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var messageLabel: FindTownLabel = {
        let label = FindTownLabel(text: messageText,
                                  font: .body3,
                                  textColor: .black,
                                  textAlignment: .center)
        label.numberOfLines = 0
        label.setLineHeight(lineHeight: 20.0)
        return label
    }()
    
    private lazy var button: FTButton = {
        let button = FTButton(style: .mediumFilled)
        button.setTitle(buttonText, for: .normal)
        return button
    }()
       
    public convenience init(messageText: String,
                            buttonText: String,
                            buttonAction: (() -> Void)? = nil) {
        self.init()

        self.messageText = messageText
        self.buttonText = buttonText
        self.button.addAction(for: .touchUpInside) { _ in
            buttonAction?()
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

private extension AlertPopUpViewController {
    
    func setLayout() {
        
        self.view.addSubview(contentView)
        
        [messageLabel, button].forEach {
            self.contentView.addSubview($0)
        }

        let view = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48.0)
        ])
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32.0),
            messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            messageLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 48.0),
            button.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 32.0),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0)
        ])
    }
}
