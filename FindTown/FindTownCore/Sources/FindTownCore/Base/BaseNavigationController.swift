//
//  File.swift
//  
//
//  Created by 이호영 on 2022/12/23.
//

import Foundation
import UIKit
import FindTownUI

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setNavigationBarAppearance()
    }
    
    func setNavigationBarAppearance() {
        let backButtonAppearance = UIBarButtonItemAppearance(style: .plain)
        backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        
        let backButtonImage = UIImage(named: "chevron.backward")
        backButtonImage?.withTintColor(FindTownColor.grey7.color)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.clear
        appearance.shadowColor = UIColor.clear
        appearance.backgroundEffect = UIBlurEffect(style: .light)
        appearance.backButtonAppearance = backButtonAppearance
        appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        
        navigationBar.tintColor = FindTownColor.grey7.color
        navigationItem.backButtonDisplayMode = .minimal
    }
}
