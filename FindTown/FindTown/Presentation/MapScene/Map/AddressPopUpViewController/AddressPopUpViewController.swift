//
//  AddressPopUpViewController.swift
//  FindTown
//
//  Created by 장선영 on 2023/01/02.
//

import Foundation
import FindTownUI
import UIKit

class AddressPopUpViewController: ContentPopUpViewController {
    let stackView = UIStackView()
    let stackView1 = UIStackView()
    let stackView2 = UIStackView()
    let stackView3 = UIStackView()
//
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "다른 동네 보기"
        topLeftButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        addView()
        setupView()
    }
    
    @objc func didTapCloseButton() {
        self.dismiss(animated: true)
    }
}

private extension AddressPopUpViewController {
    func addView() {
        self.contentView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 33.0),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24.0),
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32.0),
        ])

        [stackView1, stackView2, stackView3].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.stackView.addArrangedSubview($0)
        }

        let button1 = FTButton(style: .small)
        button1.setTitle("강남구", for: .normal)

        let button2 = FTButton(style: .small)
        button2.setTitle("강남구2", for: .normal)

        let button3 = FTButton(style: .small)
        button3.setTitle("강남구3", for: .normal)

        let button4 = FTButton(style: .small)
        button4.setTitle("강남구4", for: .normal)

        let button5 = FTButton(style: .small)
        button5.setTitle("강남구5", for: .normal)

        let button6 = FTButton(style: .small)
        button6.setTitle("강남구", for: .normal)

        let button7 = FTButton(style: .small)
        button7.setTitle("강남구2", for: .normal)

        let button8 = FTButton(style: .small)
        button8.setTitle("강남구3", for: .normal)

        let button9 = FTButton(style: .small)
        button9.setTitle("강남구4", for: .normal)

        let button10 = FTButton(style: .small)
        button10.setTitle("강남구5", for: .normal)


        let contentViewWidth = self.view.bounds.width - 32*2
        let buttonWidth = ((contentViewWidth - 24*2) - 12*2) / 3
        print(buttonWidth)

        [button1,button2,button3,button4,button5].forEach {
            $0.heightAnchor.constraint(equalToConstant: 42.0).isActive = true
            $0.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
            stackView1.addArrangedSubview($0)
        }

        [button6,button7,button8,button9,button10].forEach {
            $0.heightAnchor.constraint(equalToConstant: 42.0).isActive = true
            $0.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
            stackView2.addArrangedSubview($0)
        }
    }
    
    func setupView() {
        stackView.axis = .horizontal
        stackView.spacing = 12

        [stackView1, stackView2, stackView3].forEach {
            $0.axis = .vertical
            $0.spacing = 12
        }
    }
}
