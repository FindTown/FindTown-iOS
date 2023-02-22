//
//  File.swift
//  
//
//  Created by 이호영 on 2023/02/02.
//

import UIKit

public enum TipLocation {
    case topCenter, bottomCenter
    case topCustom(tipXPoint: CGFloat)
    case bottomCustom(tipXPoint: CGFloat)
}

public class ToolTip: UIView {
    
    var textLabel: UILabel = {
        let label = UILabel()
        label.font = FindTownFont.label2.font
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
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
        setTitle(text: text, textColor: textColor.color)
        
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
        self.layer.addCustomShadow(shadowX: 0,
                                   shadowY: 2,
                                   shadowColor: UIColor(red: 0.762, green: 0.75, blue: 0.737, alpha: 0.4),
                                   blur: 10.0,
                                   spread: 0,
                                   alpha: 0.4)
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
    
    func drawPath(tipLocation: TipLocation, width: CGFloat, height: CGFloat) {
        
        let tipWidth = CGFloat(13)
        let tipHeight = CGFloat(8)
        var tipwidthCenter = width / 2
        var endXWidth = tipwidthCenter + tipWidth
        
        switch tipLocation {
        case .topCenter:
            path.move(to: CGPoint(x: tipwidthCenter, y: 0))
            path.addLine(to: CGPoint(x: tipwidthCenter + tipWidth / 2, y: -tipHeight))
            path.addLine(to: CGPoint(x: endXWidth, y: 0))
            path.addLine(to: CGPoint(x: 0, y: 0))
        case .bottomCenter:
            path.move(to: CGPoint(x: tipwidthCenter, y: height))
            path.addLine(to: CGPoint(x: tipwidthCenter + tipWidth / 2, y: height + tipHeight))
            path.addLine(to: CGPoint(x: endXWidth + tipWidth, y: tipHeight))
            path.addLine(to: CGPoint(x: tipwidthCenter, y: 0))
        case .topCustom(let point):
            tipwidthCenter = point
            endXWidth = point + tipWidth
            path.move(to: CGPoint(x: tipwidthCenter, y: 0))
            path.addLine(to: CGPoint(x: tipwidthCenter + tipWidth / 2, y: -tipHeight))
            path.addLine(to: CGPoint(x: endXWidth, y: 0))
            path.addLine(to: CGPoint(x: 0, y: 0))
        case .bottomCustom(let point):
            tipwidthCenter = point
            endXWidth = point + tipWidth
            path.move(to: CGPoint(x: tipwidthCenter, y: height))
            path.addLine(to: CGPoint(x: tipwidthCenter + tipWidth / 2, y: height + tipHeight))
            path.addLine(to: CGPoint(x: endXWidth + tipWidth, y: tipHeight))
            path.addLine(to: CGPoint(x: tipwidthCenter, y: 0))
        }
    }
    
    func setTitle(text: String, textColor: UIColor) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.11
        textLabel.attributedText = NSMutableAttributedString(string: text,
                                                             attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle,
                                                                          NSAttributedString.Key.foregroundColor: textColor])
    }
}
