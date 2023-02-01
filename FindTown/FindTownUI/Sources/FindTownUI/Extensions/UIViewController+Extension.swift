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
}
