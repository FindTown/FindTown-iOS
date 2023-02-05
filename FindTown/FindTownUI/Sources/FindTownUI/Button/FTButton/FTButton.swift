//
//  File.swift
//
//
//  Created by 김성훈 on 2022/12/15.
//

import UIKit

public final class FTButton: UIButton {
    
    private let buttonStyle: FTButtonStyle
    
    public init(style: FTButtonStyle) {
        self.buttonStyle = style
        
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        changesSelectionAsPrimaryAction = style.isSelectedButton
        
        self.isSelected = false
        
        configuration = initConfigureUI(style: self.buttonStyle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var isSelected: Bool {
        didSet {
            configureUI(style: self.buttonStyle)
        }
    }
    
    public func setSelectedTitle(normalTitle: String, selectedTitle: String) {
        setTitle(normalTitle, for: .normal)
        setTitle(selectedTitle, for: .selected)
    }
    
    public func setSelectedImage(normalImage: UIImage?, selectedImage: UIImage?) {
        setImage(normalImage, for: .normal)
        setImage(selectedImage, for: .selected)
    }
    
    /// isEnabled, isSelected 값이 똑같이 바껴야 하는 경우 사용
    public func isEnabledAndSelected(_ isEnabledSelected: Bool) {
        self.isSelected = isEnabledSelected
        self.isEnabled = isEnabledSelected
    }
}

private extension FTButton {
    
    func configureUI(style: FTButtonStyle) {
        if style.isShadow {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = .init(width: 2, height: 4)
            layer.shadowOpacity = 0.15
            layer.shadowRadius = 6
        }
        
        self.configuration?.baseBackgroundColor = isSelected ? style.selectedColorSet[0] : style.nonSelectedColorSet[0]
        self.configuration?.baseForegroundColor = isSelected ? style.selectedColorSet[1] : style.nonSelectedColorSet[1]
        self.configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer (
            { incoming in
                var outgoing = incoming
                outgoing.font = style.titleFont
                return outgoing
            }
        )
        self.configuration?.background.cornerRadius = style.cornerRadius
        self.configuration?.contentInsets = NSDirectionalEdgeInsets(
            top: style.topBottomInset, leading: 0,
            bottom: style.topBottomInset, trailing: 0)
        if style.strokeColorSet[0] == .clear && style.strokeColorSet[1] == .clear {
            self.configuration?.background.strokeColor = .clear
        } else {
            self.configuration?.background.strokeColor = isSelected ? style.strokeColorSet[0] : style.strokeColorSet[1]
        }
        self.configuration?.background.strokeWidth = 1.0
        self.configuration?.imagePlacement = style.imagePlacement
        self.configuration?.imagePadding = style.imagePadding
    }
    
    func initConfigureUI(style: FTButtonStyle) -> Configuration {
        if style.isShadow {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = .init(width: 2, height: 4)
            layer.shadowOpacity = 0.15
            layer.shadowRadius = 6
        }
        
        var configuration = style.configuration
        configuration.baseBackgroundColor = isSelected ? style.selectedColorSet[0] : style.nonSelectedColorSet[0]
        configuration.baseForegroundColor = isSelected ? style.selectedColorSet[1] : style.nonSelectedColorSet[1]
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer (
            { incoming in
                var outgoing = incoming
                outgoing.font = style.titleFont
                return outgoing
            }
        )
        configuration.background.cornerRadius = style.cornerRadius
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: style.topBottomInset, leading: 0,
            bottom: style.topBottomInset, trailing: 0)
        if style.strokeColorSet[0] == .clear && style.strokeColorSet[1] == .clear {
            configuration.background.strokeColor = .clear
        } else {
            configuration.background.strokeColor = isSelected ? style.strokeColorSet[0] : style.strokeColorSet[1]
        }
        configuration.background.strokeWidth = 1.0
        configuration.imagePlacement = style.imagePlacement
        configuration.imagePadding = style.imagePadding
        
        return configuration
    }
}
