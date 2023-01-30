//
//  TrafficTipView.swift
//  FindTown
//
//  Created by 장선영 on 2023/01/29.
//

import UIKit
import FindTownUI

final class TrafficTipView: UIView {
    
    private let trafficLabel = FindTownLabel(text: "1",
                                             font: .body3,
                                             textColor: .white,
                                             textAlignment: .center)
    
    convenience init(type: Traffic) {
        self.init(frame: .zero)
        trafficLabel.text = type.shortDescription
        
        switch type {
        case .one:
            self.backgroundColor = UIColor(red: 38, green: 60, blue: 150)
        case .two:
            self.backgroundColor = UIColor(red: 60, green: 180, blue: 74)
        case .three:
            self.backgroundColor = UIColor(red: 255, green: 115, blue: 0)
        case .four:
            self.backgroundColor = UIColor(red: 44, green: 158, blue: 222)
        case .five:
            self.backgroundColor = UIColor(red: 137, green: 54, blue: 224)
        case .six:
            self.backgroundColor = UIColor(red: 181, green: 80, blue: 11)
        case .seven:
            self.backgroundColor = UIColor(red: 105, green: 114, blue: 21)
        case .eight:
            self.backgroundColor = UIColor(red: 229, green: 30, blue: 110)
        case .nine:
            self.backgroundColor = UIColor(red: 209, green: 166, blue: 44)
        case .gyeonguijungang:
            self.backgroundColor = UIColor(red: 124, green: 196, blue: 165)
        case .gonghangcheoldo:
            self.backgroundColor = UIColor(red: 115, green: 182, blue: 228)
        case .suinbundang:
            self.backgroundColor = UIColor(red: 255, green: 206, blue: 51)
        case .sinrimseon:
            self.backgroundColor = UIColor(red: 125, green: 154, blue: 223)
        case .sinbundang:
            self.backgroundColor = UIColor(red: 167, green: 30, blue: 49)
        case .uisinseol:
            self.backgroundColor = UIColor(red: 179, green: 199, blue: 62)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
}

private extension TrafficTipView {
    func setupView() {
        self.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        self.widthAnchor.constraint(greaterThanOrEqualToConstant: 20.0).isActive = true
        self.layer.cornerRadius = 10
        
        self.addSubview(trafficLabel)
        trafficLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            trafficLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            trafficLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            trafficLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 6.0)
        ])
    }
}
