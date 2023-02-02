//
//  File.swift
//  
//
//  Created by 이호영 on 2023/02/02.
//

import UIKit

public enum TipLocation {
    case top, bottom
}

public class ToolTip: UIView {
    
    var textLabel: UILabel = {
        let label = UILabel()
        label.font = FindTownFont.label2.font
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var shape = CAShapeLayer()
    var path = CGMutablePath()
    
    public init(text: String,
                viewColor: FindTownColor,
                textColor: FindTownColor,
                tipLocation: TipLocation,
                width: CGFloat,
                height: CGFloat) {
        super.init(frame: .zero)
        
        self.backgroundColor = viewColor.color
        self.textLabel.text = text
        self.textLabel.textColor = textColor.color
        
        drawPath(tipLocation: tipLocation, width: width, height: height)

        shape.path = path
        shape.fillColor = viewColor.color.cgColor

        setupView()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func dismiss() {
        self.alpha = 0
    }
    
    func setupView() {
        self.layer.insertSublayer(shape, at: 0)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 10
        self.layer.shadowColor = FindTownColor.grey4.color.cgColor
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 8
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setLayout() {
        self.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            textLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -13),
            textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13),
        ])
    }
    
//    func drawPath(tipLocation: TipLocation, width: CGFloat, height: CGFloat) {
//        let tipWidth = 13
//        let tipHeight = 8
//        let tipwidthCenter = width / 2
//        let endXWidth = tipwidthCenter + 16
//
//        switch tipLocation {
//        case .top:
//            path.move(to: CGPoint(x: tipwidthCenter, y: tipHeight))
//            path.addLine(to: CGPoint(x: tipwidthCenter + 6.6, y: tipHeight + 8))
//            path.addLine(to: CGPoint(x: endXWidth, y: tipHeight))
//            path.addLine(to: CGPoint(x: tipwidthCenter, y: 0))
//        case .bottom:
//            path.move(to: CGPoint(x: tipwidthCenter, y: 0))
//            path.addLine(to: CGPoint(x: tipwidthCenter + 6.6, y: -8))
//            path.addLine(to: CGPoint(x: endXWidth, y: 0))
//            path.addLine(to: CGPoint(x: 0, y: 0))
//        }
//
//
//    }
    
    func drawPath(tipLocation: TipLocation, width: CGFloat, height: CGFloat) {
        let tipWidth = CGFloat(13)
        let tipHeight = CGFloat(8)
        let tipwidthCenter = width / 2
        let endXWidth = tipwidthCenter + tipWidth
        
        switch tipLocation {
        case .top:
            path.move(to: CGPoint(x: tipwidthCenter, y: 0))
            path.addLine(to: CGPoint(x: tipwidthCenter + tipWidth / 2, y: -tipHeight))
            path.addLine(to: CGPoint(x: endXWidth, y: 0))
            path.addLine(to: CGPoint(x: 0, y: 0))
        case .bottom:
            path.move(to: CGPoint(x: tipwidthCenter, y: height))
            path.addLine(to: CGPoint(x: tipwidthCenter + tipWidth / 2, y: height + tipHeight))
            path.addLine(to: CGPoint(x: endXWidth + tipWidth, y: tipHeight))
            path.addLine(to: CGPoint(x: tipwidthCenter, y: 0))
        }
    }
}
