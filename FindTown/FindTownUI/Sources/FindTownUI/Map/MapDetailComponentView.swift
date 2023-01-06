//
//  File.swift
//  
//
//  Created by 장선영 on 2023/01/02.
//

import Foundation
import UIKit

public class MapDetailComponentView: UIView {
    
    public var colorView = UIView()
    public var textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MapDetailComponentView {
    
    func setupView() {
        colorView.layer.cornerRadius = 4
        textLabel.font = FindTownFont.label4.font
        textLabel.textColor = FindTownColor.black.color
    }
    
    func setupLayout() {
        [colorView, textLabel].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            colorView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            colorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 8.0),
            colorView.heightAnchor.constraint(equalToConstant: 8.0)
        ])
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 4.0),
            textLabel.topAnchor.constraint(equalTo: self.topAnchor),
            textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
