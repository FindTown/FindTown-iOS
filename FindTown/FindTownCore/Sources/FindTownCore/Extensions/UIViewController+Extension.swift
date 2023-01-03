//
//  File.swift
//  
//
//  Created by 장선영 on 2022/12/28.
//

import Foundation
import UIKit

extension UIViewController {

    /// 화면 탭시 키보드 숨기기
    public func hideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(UIViewController.dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
}

private extension UIViewController {
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
