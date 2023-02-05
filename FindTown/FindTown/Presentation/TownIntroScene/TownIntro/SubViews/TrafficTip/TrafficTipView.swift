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
        self.backgroundColor = type.color
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
