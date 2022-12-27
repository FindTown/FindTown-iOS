//
//  File.swift
//  
//
//  Created by 김성훈 on 2022/12/15.
//

import UIKit

public struct FTButtonStyle {
    let configuration: UIButton.Configuration
    let titleFont: UIFont
    let backgroundColor: UIColor
    let foregroundColor: UIColor
    var strokeColor: UIColor = .clear
    let topBottomInset: CGFloat
    let leftRightInset: CGFloat
    let cornerRadius: CGFloat
    var imagePlacement: NSDirectionalRectEdge = .all
    var imagePadding: CGFloat = 0.0
    var isShadow: Bool = false
    var strokeWidth: Double = 1
}

extension FTButtonStyle {
    public static let largeSelected = FTButtonStyle (
        configuration: .tinted(),
        titleFont: FindTownFont.body3.font,
        backgroundColor: FindTownColor.white.color,
        foregroundColor: FindTownColor.primary.color,
        topBottomInset: 14,
        leftRightInset: 0,
        cornerRadius: 10
    )
    
    public static let largeNonSelected = FTButtonStyle (
        configuration: .tinted(),
        titleFont: FindTownFont.body3.font,
        backgroundColor: FindTownColor.white.color,
        foregroundColor: FindTownColor.grey5.color,
        topBottomInset: 14,
        leftRightInset: 0,
        cornerRadius: 10
    )
    
    public static let mediumFilled = FTButtonStyle (
        configuration: .filled(),
        titleFont: FindTownFont.body3.font,
        backgroundColor: FindTownColor.primary.color,
        foregroundColor: FindTownColor.white.color,
        topBottomInset: 12,
        leftRightInset: 50,
        cornerRadius: 10
    )

    public static let mediumTintedWithOpacity = FTButtonStyle (
        configuration: .tinted(),
        titleFont: FindTownFont.body3.font,
        backgroundColor: FindTownColor.primary10.color,
        foregroundColor: FindTownColor.primary.color,
        topBottomInset: 12,
        leftRightInset: 50,
        cornerRadius: 10,
        strokeWidth: 0.0
    )

    public static let mediumTintedWithRadius = FTButtonStyle (
        configuration: .tinted(),
        titleFont: FindTownFont.body3.font,
        backgroundColor: FindTownColor.white.color,
        foregroundColor: FindTownColor.primary.color,
        topBottomInset: 12,
        leftRightInset: 50,
        cornerRadius: 10
    )

    public static let smallSelected = FTButtonStyle (
        configuration: .tinted(),
        titleFont: FindTownFont.body3.font,
        backgroundColor: FindTownColor.white.color,
        foregroundColor: FindTownColor.primary.color,
        topBottomInset: 11,
        leftRightInset: 40,
        cornerRadius: 10
    )
    
    public static let smallNonSelected = FTButtonStyle (
        configuration: .tinted(),
        titleFont: FindTownFont.body3.font,
        backgroundColor: FindTownColor.white.color,
        foregroundColor: FindTownColor.grey4.color,
        topBottomInset: 11,
        leftRightInset: 40,
        cornerRadius: 10
    )

    public static let xSmallSelected = FTButtonStyle (
        configuration: .tinted(),
        titleFont: FindTownFont.body3.font,
        backgroundColor: FindTownColor.white.color,
        foregroundColor: FindTownColor.primary.color,
        topBottomInset: 8,
        leftRightInset: 25,
        cornerRadius: 10
    )
    
    public static let xSmallNonSelected = FTButtonStyle (
        configuration: .tinted(),
        titleFont: FindTownFont.body3.font,
        backgroundColor: FindTownColor.white.color,
        foregroundColor: FindTownColor.grey4.color,
        topBottomInset: 8,
        leftRightInset: 25,
        cornerRadius: 10
    )
    
    public static let xxSmallSelected = FTButtonStyle (
        configuration: .tinted(),
        titleFont: FindTownFont.label2.font,
        backgroundColor: FindTownColor.white.color,
        foregroundColor: FindTownColor.primary.color,
        topBottomInset: 8,
        leftRightInset: 8,
        cornerRadius: 10
    )
    
    public static let xxSmallNonSelected = FTButtonStyle (
        configuration: .tinted(),
        titleFont: FindTownFont.label2.font,
        backgroundColor: FindTownColor.white.color,
        foregroundColor: FindTownColor.grey4.color,
        topBottomInset: 8,
        leftRightInset: 8,
        cornerRadius: 10
    )

    public static let buttonFilterSelected = FTButtonStyle (
        configuration: .tinted(),
        titleFont: FindTownFont.label1.font,
        backgroundColor: FindTownColor.white.color,
        foregroundColor: FindTownColor.primary.color,
        topBottomInset: 12,
        leftRightInset: 20,
        cornerRadius: 30,
        imagePlacement: .trailing,
        imagePadding: 5
    )
    
    public static let buttonFilterNonSelected = FTButtonStyle (
        configuration: .tinted(),
        titleFont: FindTownFont.label1.font,
        backgroundColor: FindTownColor.white.color,
        foregroundColor: FindTownColor.grey4.color,
        topBottomInset: 12,
        leftRightInset: 20,
        cornerRadius: 30,
        imagePlacement: .trailing,
        imagePadding: 5
    )

    public static let iconFilterSelected = FTButtonStyle (
        configuration: .filled(),
        titleFont: FindTownFont.body4.font,
        backgroundColor: FindTownColor.primary.color,
        foregroundColor: FindTownColor.white.color,
        topBottomInset: 8,
        leftRightInset: 20,
        cornerRadius: 30,
        imagePlacement: .leading,
        imagePadding: 5,
        isShadow: true
    )
    
    public static let iconFilterNonSelected = FTButtonStyle (
        configuration: .filled(),
        titleFont: FindTownFont.body4.font,
        backgroundColor: FindTownColor.white.color,
        foregroundColor: FindTownColor.grey6.color,
        strokeColor: FindTownColor.grey2.color,
        topBottomInset: 8,
        leftRightInset: 20,
        cornerRadius: 30,
        imagePlacement: .leading,
        imagePadding: 5,
        isShadow: true
    )

    public static let roundSelected = FTButtonStyle (
        configuration: .filled(),
        titleFont: FindTownFont.body4.font,
        backgroundColor: FindTownColor.white.color,
        foregroundColor: FindTownColor.grey7.color,
        strokeColor: FindTownColor.grey3.color,
        topBottomInset: 12,
        leftRightInset: 20,
        cornerRadius: 30,
        imagePlacement: .leading,
        imagePadding: 5,
        isShadow: true
    )
    
    public static let roundNonSelected = FTButtonStyle (
        configuration: .filled(),
        titleFont: FindTownFont.body4.font,
        backgroundColor: FindTownColor.black.color,
        foregroundColor: FindTownColor.white.color,
        topBottomInset: 12,
        leftRightInset: 20,
        cornerRadius: 30,
        imagePlacement: .leading,
        imagePadding: 5,
        isShadow: true
    )

    public static let iconSelected = FTButtonStyle (
        configuration: .tinted(),
        titleFont: FindTownFont.label1.font,
        backgroundColor: FindTownColor.white.color,
        foregroundColor: FindTownColor.primary.color,
        topBottomInset: 8,
        leftRightInset: 20,
        cornerRadius: 0,
        imagePlacement: .top,
        imagePadding: 10,
        strokeWidth: 0.0
    )
    
    public static let iconNonSelected = FTButtonStyle (
        configuration: .tinted(),
        titleFont: FindTownFont.label1.font,
        backgroundColor: FindTownColor.white.color,
        foregroundColor: FindTownColor.grey4.color,
        topBottomInset: 8,
        leftRightInset: 20,
        cornerRadius: 0,
        imagePlacement: .top,
        imagePadding: 10,
        strokeWidth: 0.0
    )
}
