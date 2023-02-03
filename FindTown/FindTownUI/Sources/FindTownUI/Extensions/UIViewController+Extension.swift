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
    
    /// AlertPopUpVC 띄워 줌
    public func showErrorNoticeAlertPopUp(message: String, buttonText: String, buttonAction: (() -> Void)? = nil) {
        let alertPopUp = NoticeAlertPopUpViewController(titleText: "", messageText: message, confirmButtonText: buttonText, confirmButtonAction: buttonAction)
        present(alertPopUp, animated: false)
    }
}
