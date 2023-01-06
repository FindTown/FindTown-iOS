//
//  HomeViewController.swift
//  FindTown
//
//  Created by 이호영 on 2022/12/25.
//

import UIKit
import FindTownCore
import FindTownUI

class HomeViewController: BaseViewController {

    var viewModel: HomeViewModel?
    
    private let button: FTButton = {
        let button = FTButton(style: .largeFilled)
        button.setTitle("push", for: .normal)
        return button
    }()
    
    private let button2: FTButton = {
        let button = FTButton(style: .largeFilled)
        button.setTitle("present", for: .normal)
        return button
    }()
    
    private let button3: FTButton = {
        let button = FTButton(style: .largeFilled)
        button.setTitle("dismiss", for: .normal)
        return button
    }()
    
    private let button4: FTButton = {
        let button = FTButton(style: .largeFilled)
        button.setTitle("pop", for: .normal)
        return button
    }()
    
    private let button5: FTButton = {
        let button = FTButton(style: .largeFilled)
        button.setTitle("setVC", for: .normal)
        return button
    }()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = FindTownColor.primary.color
        
        view.addSubview(button)
        view.addSubview(button2)
        view.addSubview(button3)
        view.addSubview(button4)
        view.addSubview(button5)
        
        button.topAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        button4.topAnchor.constraint(equalTo: button.topAnchor, constant: 100).isActive = true
        button4.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        button2.topAnchor.constraint(equalTo: button4.topAnchor, constant: 100).isActive = true
        button2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        button3.topAnchor.constraint(equalTo: button2.topAnchor, constant: 100).isActive = true
        button3.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        button5.topAnchor.constraint(equalTo: button3.topAnchor, constant: 100).isActive = true
        button5.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        button.addTarget(self, action: #selector(action), for: .touchUpInside)
        button2.addTarget(self, action: #selector(action2), for: .touchUpInside)
        button3.addTarget(self, action: #selector(action3), for: .touchUpInside)
        button4.addTarget(self, action: #selector(action4), for: .touchUpInside)
        button5.addTarget(self, action: #selector(action5), for: .touchUpInside)
    }
    
    @objc func action() {
        viewModel?.push()
    }
    
    @objc func action4() {
        viewModel?.pop()
    }

    @objc func action2() {
        viewModel?.present()
    }

    @objc func action3() {
        viewModel?.dismiss()
    }
    
    @objc func action5() {
        viewModel?.setViewController()
    }
}
