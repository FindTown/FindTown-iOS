//
//  ContentPopUpViewController.swift
//  
//
//  Created by 장선영 on 2022/12/28.
//

import UIKit

/// 사용자 지정 콘텐츠View가 들어가는 팝업 VC
open class ContentPopUpViewController: UIViewController {
        
    public var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = FindTownColor.white.color
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public var topLeftButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(FindTownColor.black.color, for: .normal)
        button.setImage(UIImage(named: "Close", in: .module, compatibleWith: nil), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public var titleLabel: FindTownLabel = {
        let label = FindTownLabel(text: "",
                                  font: .body1,
                                  textColor: .black,
                                  textAlignment: .center)
        label.setLineHeight(lineHeight: 24.0)
        return label
    }()

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = FindTownColor.dim70.color
        modalPresentationStyle = .overFullScreen
        
        setLayout()
    }
}

private extension ContentPopUpViewController {
    
    func setLayout() {
        
        self.view.addSubview(contentView)
        
        [topLeftButton, titleLabel].forEach {
            self.contentView.addSubview($0)
        }
        
        let view = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 19.0)
        ])
        
        NSLayoutConstraint.activate([
            topLeftButton.widthAnchor.constraint(equalToConstant: 14.0),
            topLeftButton.heightAnchor.constraint(equalToConstant: 14.0),
            topLeftButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24.0),
            topLeftButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
    }
}
