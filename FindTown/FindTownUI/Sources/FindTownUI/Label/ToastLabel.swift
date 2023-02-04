//
//  File.swift
//  
//
//  Created by 이호영 on 2023/02/05.
//

import UIKit

class ToastLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        textColor = UIColor.white
        textAlignment = .left
        alpha = 1.0
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
    func setMessage(text: String, font: UIFont, frame: CGRect) {
        self.font = font
        self.text = text
        self.frame = frame
    }
}
