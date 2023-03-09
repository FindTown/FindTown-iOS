//
//  File.swift
//  
//
//  Created by 이호영 on 2023/02/24.
//

import Foundation
import UIKit

public class InformLabel: UILabel {

    private var padding = UIEdgeInsets(top: 12.0, left: 16.0, bottom: 12.0, right: 16.0)
    
    public init(text: String) {
                    
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        self.text = text
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    func setupView() {
        backgroundColor = UIColor.black
        textColor = UIColor.white
        textAlignment = .left
        alpha = 1.0
        layer.cornerRadius = 8
        clipsToBounds = true
    }
}
