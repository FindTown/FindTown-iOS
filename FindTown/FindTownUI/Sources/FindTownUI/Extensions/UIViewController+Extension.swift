//
//  File.swift
//  
//
//  Created by 장선영 on 2022/12/21.
//

import Foundation
import UIKit

extension UIViewController {

    /// 화면 탭시 키보드 숨기기
    public func hideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    /// AlertPopUpVC 띄워 줌
    public func showAlertPopUp(message: String, buttonText: String, buttonAction: @escaping () -> Void) {
        let alertPopUp = AlertPopUpViewController(messageText: message,
                                                  buttonText: buttonText,
                                                  buttonAction: buttonAction)
        present(alertPopUp, animated: false)
    }
}

private extension UIViewController {
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
