//
//  File.swift
//  
//
//  Created by 김성훈 on 2022/12/18.
//

import UIKit

open class BaseViewController: UIViewController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        addView()
        setupView()
        setLayout()
        
        bindViewModel()
    }
    
    open func addView() {}
    open func setupView() {}
    open func setLayout() {}
    
    open func bindViewModel() {}
}
