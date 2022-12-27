//
//  File.swift
//  
//
//  Created by 김성훈 on 2022/12/15.
//

import UIKit

public final class FTButton: UIButton {
    
    private let style: FTButtonStyle
    
    public init(frame: CGRect = .zero, style: FTButtonStyle) {
        self.style = style
        
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        isSelected = false
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        if style.isShadow {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = .init(width: 2, height: 4)
            layer.shadowOpacity = 0.15
            layer.shadowRadius = 6
        }
        
        var configuration = style.configuration
        configuration.baseBackgroundColor = style.backgroundColor
        configuration.baseForegroundColor = style.foregroundColor
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer (
            { [weak self] incoming in
                var outgoing = incoming
                outgoing.font = self?.style.titleFont
                return outgoing
            }
        )
        configuration.background.cornerRadius = style.cornerRadius
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 12, leading: style.inset, bottom: 12, trailing: style.inset
        )
        configuration.background.strokeColor = style.strokeColor == .clear
        ? style.foregroundColor : style.strokeColor
        configuration.background.strokeWidth = style.strokeWidth
        configuration.imagePlacement = style.imagePlacement
        configuration.imagePadding = style.imagePadding
        
        self.configuration = configuration
    }
}
