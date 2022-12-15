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
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var isSelected: Bool {
        didSet {
            switch isSelected {
            case true:
                configuration?.background.strokeColor = style.selectedBaseColor
                configuration?.baseForegroundColor = style.selectedBaseColor
                configuration?.baseBackgroundColor = style.selectedBackgroundColor
            case false:
                configuration?.background.strokeColor = style.nonSelectedBaseColor
                configuration?.baseForegroundColor = style.nonSelectedBaseColor
                configuration?.baseBackgroundColor = style.nonSelectedBackgroundColor
            }
        }
    }
    
    public func setSelectedTitle(normalTitle: String = .init(), selectedTitle: String = .init()) {
        setTitle(normalTitle, for: .normal)
        setTitle(selectedTitle, for: .selected)
    }
    
    public func setSelectedImage(normalImage: UIImage = .init(), selectedImage: UIImage = .init()) {
        setImage(normalImage, for: .normal)
        setImage(selectedImage, for: .selected)
    }
    
    private func configureUI() {
        if style.isShadow {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = .init(width: 4, height: 4)
            layer.shadowOpacity = 0.2
            layer.shadowRadius = 5
        }
        
        var config = style.configu
        config.baseBackgroundColor = style.selectedBackgroundColor
        config.baseForegroundColor = style.nonSelectedBaseColor
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
        config.background.strokeColor = style.nonSelectedBaseColor
        config.background.strokeWidth = style.strokeWidth
        config.imagePlacement = style.imagePlacement
        config.imagePadding = style.imagePadding
        
        configuration = config
        
        isSelected = false
    }
}
