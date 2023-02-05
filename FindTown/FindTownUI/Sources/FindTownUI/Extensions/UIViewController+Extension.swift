//
//  File.swift
//  
//
//  Created by 장선영 on 2022/12/21.
//

import Foundation
import UIKit

extension UIViewController {
    
    /// AlertPopUpVC 띄워 줌
    public func showAlertPopUp(message: String, buttonText: String, buttonAction: @escaping () -> Void) {
        let alertPopUp = AlertPopUpViewController(messageText: message,
                                                  buttonText: buttonText,
                                                  buttonAction: buttonAction)
        present(alertPopUp, animated: false)
    }
    
    /// select, cancel 버튼을 가지는 PopUp 띄워 줌
    public func showAlertSuccessCancelPopUp(title: String, message: String = "", successButtonText: String, cancelButtonText: String, successButtonAction: @escaping () -> Void, cancelButtonAction: @escaping () -> Void = { }) {
        
        let dismissAction: () -> Void = { self.dismiss(animated: false, completion: nil) }
        let finalCancelButtonAction = cancelButtonAction() == { }() ? dismissAction : cancelButtonAction
        
        let alertPopUp = AlertSuccessCancelPopUpViewController(titleText: title,
                                                               messageText: message,
                                                               successButtonText: successButtonText,
                                                               cancelButtonText: cancelButtonText,
                                                               successButtonAction: successButtonAction,
                                                               cancelButtonAction: finalCancelButtonAction)
        
        present(alertPopUp, animated: false)
    }
    
    /// toast 메세지
    public func showToast(message: String) {
        let toastLabel = ToastLabel()
        let screenWidth = self.view.frame.size.width
        let toastLabelFrame = CGRect(x: 12, y: self.view.frame.size.height - 150, width: screenWidth-24, height: 44)
        toastLabel.setMessage(text: message, font: FindTownFont.body3.font, frame: toastLabelFrame)
        self.view.addSubview(toastLabel)
        self.view.endEditing(true)
        UIView.animate(withDuration: 2.0, delay: 2.0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
}
