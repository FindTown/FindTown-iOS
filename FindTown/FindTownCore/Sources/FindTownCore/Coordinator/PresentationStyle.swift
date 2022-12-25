//
//  File.swift
//  
//
//  Created by 이호영 on 2022/12/25.
//

import UIKit

public enum PresentationStyle {
    case push(navigationController: UINavigationController)
    case present(presenter: UINavigationController)
    case setViewController(navigationController: UINavigationController)
    case none
}
