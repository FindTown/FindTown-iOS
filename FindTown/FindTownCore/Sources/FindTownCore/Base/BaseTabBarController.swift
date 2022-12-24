//
//  File.swift
//  
//
//  Created by 이호영 on 2022/12/23.
//

import UIKit
import FindTownUI

public class BaseTabBarController: UITabBarController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        setTabBarAppearance()
    }
    
    func setTabBarAppearance() {
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = FindTownColor.grey6.color
        itemAppearance.normal.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: FindTownColor.grey6.color,
            NSAttributedString.Key.font: FindTownFont.label4.font
        ]
        
        itemAppearance.selected.iconColor = FindTownColor.primary.color
        itemAppearance.selected.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: FindTownColor.primary.color,
            NSAttributedString.Key.font: FindTownFont.label4.font
        ]
        
        let appearance = UITabBarAppearance()
        
        appearance.configureWithDefaultBackground()
        appearance.backgroundEffect = .none
        appearance.backgroundColor = FindTownColor.white.color
        appearance.shadowColor = FindTownColor.white.color
        
        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance
        
        tabBar.scrollEdgeAppearance = appearance
        tabBar.standardAppearance = appearance
    }
}
