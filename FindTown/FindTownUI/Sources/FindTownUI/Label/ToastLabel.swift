//
//  File.swift
//  
//
//  Created by 이호영 on 2023/02/05.
//

import UIKit

class ToastLabel: UILabel {

    private var padding = UIEdgeInsets(top: 12.0, left: 16.0, bottom: 12.0, right: 16.0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func drawText(in rect: CGRect) {
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
    
    func setMessage(text: String, font: UIFont, frame: CGRect) {
        self.font = font
        self.text = text
        self.frame = frame
    }
}
