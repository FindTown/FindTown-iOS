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
            layer.shadowOffset = .init(width: 4, height: 4)
            layer.shadowOpacity = 0.2
            layer.shadowRadius = 5
        }
        
        var config = style.configuration
        config.baseBackgroundColor = style.backgroundColor
        config.baseForegroundColor = style.foregroundColor
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer (
            { [weak self] incoming in
                var outgoing = incoming
                outgoing.font = self?.style.titleFont
                return outgoing
            }
        )
        config.background.cornerRadius = style.cornerRadius
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 12, leading: style.inset, bottom: 12, trailing: style.inset
        )
        config.background.strokeColor = style.foregroundColor
        config.background.strokeWidth = style.strokeWidth
        config.imagePlacement = style.imagePlacement
        config.imagePadding = style.imagePadding
        
        configuration = config
    }
}
