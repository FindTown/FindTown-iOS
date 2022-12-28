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
}

