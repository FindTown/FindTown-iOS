//
//  File.swift
//  
//
//  Created by 이호영 on 2022/12/23.
//

import UIKit
import FindTownUI

public class BaseNavigationController: UINavigationController {

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setNavigationBarAppearance()
    }
    
    func setNavigationBarAppearance() {
        let backButtonAppearance = UIBarButtonItemAppearance(style: .plain)
        backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        
        let backButtonImage = UIImage(named: "Back")?.withAlignmentRectInsets(UIEdgeInsets(top: 0.0, left: -8.0, bottom: -8.0, right: 0.0))
        backButtonImage?.withTintColor(FindTownColor.grey7.color)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = FindTownColor.white.color
        appearance.shadowColor = UIColor.clear
        appearance.backgroundEffect = UIBlurEffect(style: .light)
        appearance.backButtonAppearance = backButtonAppearance
        appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        
        navigationBar.tintColor = FindTownColor.grey7.color
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: FindTownColor.black.color,
            NSAttributedString.Key.font: FindTownFont.subtitle4
        ]
        navigationItem.backButtonDisplayMode = .minimal
    }
}
