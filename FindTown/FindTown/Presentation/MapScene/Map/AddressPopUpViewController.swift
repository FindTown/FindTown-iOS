//
//  AddressPopUpViewController.swift
//  FindTown
//
//  Created by 장선영 on 2023/01/05.
//

import Foundation
import FindTownUI
import UIKit

/// 다른 동네를 선택할 수 있는 팝업 화면 
class AddressPopUpViewController: ContentPopUpViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "다른 동네 보기"
        topLeftButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        
        let tempView = UIView()
        tempView.backgroundColor = FindTownColor.grey3.color
        tempView.translatesAutoresizingMaskIntoConstraints = false
            
        contentView.addSubview(tempView)
            
        NSLayoutConstraint.activate([
            tempView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            tempView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20.0),
            tempView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            tempView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30.0),
            tempView.heightAnchor.constraint(equalToConstant: 300.0)
        ])
    }
    
    @objc func didTapCloseButton() {
        self.dismiss(animated: true)
    }
}
