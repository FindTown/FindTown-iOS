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
    public func showAlertSuccessCancelPopUp(title: String = "", message: String = "", successTitle: String,
                                            cancelTitle: String , buttonAction: @escaping () -> Void)
    {
        let alert = UIAlertController(title: title == "" ? nil : title,
                                      message: message == "" ? nil : message,
                                      preferredStyle: .alert)
        
        let alertSuccessBtn = UIAlertAction(title: successTitle, style: .default) { (action) in
            buttonAction()
        }
        let alertCaccelBtn = UIAlertAction(title: cancelTitle, style: .default) { (action) in }

        alertSuccessBtn.setValue(FindTownColor.primary.color, forKey: "titleTextColor")
        alertCaccelBtn.setValue(FindTownColor.grey5.color, forKey: "titleTextColor")
        
        alert.addAction(alertCaccelBtn)
        alert.addAction(alertSuccessBtn)
        
        present(alert, animated: false, completion: nil)
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
