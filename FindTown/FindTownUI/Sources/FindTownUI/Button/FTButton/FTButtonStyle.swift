//
//  File.swift
//  
//
//  Created by 김성훈 on 2022/12/15.
//

import UIKit

public struct FTButtonStyle {
    let isSelectedButton: Bool
    let configuration: UIButton.Configuration
    let titleFont: UIFont
    var selectedColorSet: [UIColor] = []
    let nonSelectedColorSet: [UIColor]
    var strokeColor: UIColor = .black
    let topBottomInset: CGFloat
    let cornerRadius: CGFloat
    var imagePlacement: NSDirectionalRectEdge = .all
    var imagePadding: CGFloat = 0.0
    var isShadow: Bool = false
}

extension FTButtonStyle {
    
    /// Button_L - 첫번째 두번째 버튼 세트
    public static let largeFilled = FTButtonStyle (
        isSelectedButton: true,
        configuration: .filled(),
        titleFont: FindTownFont.body3.font,
        selectedColorSet: [FindTownColor.primary.color, FindTownColor.white.color],
        nonSelectedColorSet: [FindTownColor.grey3.color, FindTownColor.grey5.color],
        strokeColor: .clear,
        topBottomInset: 14,
        cornerRadius: 10
    )
    
    /// Button_L - 세번째 네번째 버튼 세트
    public static let largeTinted = FTButtonStyle (
        isSelectedButton: true,
        configuration: .tinted(),
        titleFont: FindTownFont.body3.font,
        selectedColorSet: [FindTownColor.white.color, FindTownColor.primary.color],
        nonSelectedColorSet: [FindTownColor.white.color, FindTownColor.grey5.color],
        topBottomInset: 14,
        cornerRadius: 10
    )
    
    /// Button_M - 첫번째 버튼
    public static let mediumFilled = FTButtonStyle (
        isSelectedButton: false,
        configuration: .filled(),
        titleFont: FindTownFont.body3.font,
        nonSelectedColorSet: [FindTownColor.primary.color, FindTownColor.white.color],
        topBottomInset: 12,
        cornerRadius: 10
    )
    
    /// Button_M - 두번째 네번째 버튼 세트
    public static let mediumTintedWithRadius = FTButtonStyle (
        isSelectedButton: true,
        configuration: .tinted(),
        titleFont: FindTownFont.body3.font,
        selectedColorSet: [FindTownColor.white.color, FindTownColor.primary.color],
        nonSelectedColorSet: [FindTownColor.white.color, FindTownColor.grey5.color],
        topBottomInset: 12,
        cornerRadius: 10
    )
    
    /// Button_M - 세번째 버튼
    public static let mediumTintedWithOpacity = FTButtonStyle (
        isSelectedButton: false,
        configuration: .tinted(),
        titleFont: FindTownFont.body3.font,
        nonSelectedColorSet: [FindTownColor.primary10.color, FindTownColor.primary.color],
        strokeColor: .clear,
        topBottomInset: 12,
        cornerRadius: 10
    )
    
    /// Button_S
    public static let small = FTButtonStyle (
        isSelectedButton: true,
        configuration: .tinted(),
        titleFont: FindTownFont.body3.font,
        selectedColorSet: [FindTownColor.white.color, FindTownColor.primary.color],
        nonSelectedColorSet: [FindTownColor.white.color, FindTownColor.grey4.color],
        topBottomInset: 11,
        cornerRadius: 10
    )
    
    /// Button_XS
    public static let xSmall = FTButtonStyle (
        isSelectedButton: true,
        configuration: .tinted(),
        titleFont: FindTownFont.body3.font,
        selectedColorSet: [FindTownColor.white.color, FindTownColor.primary.color],
        nonSelectedColorSet: [FindTownColor.white.color, FindTownColor.grey4.color],
        topBottomInset: 8,
        cornerRadius: 10
    )
    
    /// Button_XXS
    public static let xxSmall = FTButtonStyle (
        isSelectedButton: true,
        configuration: .tinted(),
        titleFont: FindTownFont.label2.font,
        selectedColorSet: [FindTownColor.white.color, FindTownColor.primary.color],
        nonSelectedColorSet: [FindTownColor.white.color, FindTownColor.grey4.color],
        topBottomInset: 8,
        cornerRadius: 10
    )
    
    /// Button_Filter_Chip - 첫번째 두번째 버튼 세트
    public static let buttonFilter = FTButtonStyle (
        isSelectedButton: true,
        configuration: .tinted(),
        titleFont: FindTownFont.label1.font,
        selectedColorSet: [FindTownColor.white.color, FindTownColor.primary.color],
        nonSelectedColorSet: [FindTownColor.white.color, FindTownColor.grey4.color],
        topBottomInset: 12,
        cornerRadius: 30,
        imagePlacement: .trailing,
        imagePadding: 5
    )
    
    /// Button_Filter_Chip - 세번째 버튼
    public static let buttonFilterNormal = FTButtonStyle (
        isSelectedButton: false,
        configuration: .tinted(),
        titleFont: FindTownFont.label1.font,
        nonSelectedColorSet: [FindTownColor.white.color, FindTownColor.grey5.color],
        topBottomInset: 12,
        cornerRadius: 30,
        imagePlacement: .leading,
        imagePadding: 5
    )
    
    /// Icon_Filter_Chip - 첫번째 두번째 버튼 세트
    public static let iconFilter = FTButtonStyle (
        isSelectedButton: true,
        configuration: .filled(),
        titleFont: FindTownFont.body4.font,
        selectedColorSet: [FindTownColor.primary.color, FindTownColor.white.color],
        nonSelectedColorSet: [FindTownColor.white.color, FindTownColor.grey6.color],
        strokeColor: .clear,
        topBottomInset: 8,
        cornerRadius: 30,
        imagePlacement: .leading,
        imagePadding: 5,
        isShadow: true
    )
    
    /// Round Button
    public static let round = FTButtonStyle (
        isSelectedButton: true,
        configuration: .filled(),
        titleFont: FindTownFont.body4.font,
        selectedColorSet: [FindTownColor.white.color, FindTownColor.grey7.color],
        nonSelectedColorSet: [FindTownColor.black.color, FindTownColor.white.color],
        strokeColor: FindTownColor.grey3.color,
        topBottomInset: 12,
        cornerRadius: 30,
        imagePlacement: .leading,
        imagePadding: 5,
        isShadow: true
    )
    
    /// Icon Button
    public static let icon = FTButtonStyle (
        isSelectedButton: true,
        configuration: .tinted(),
        titleFont: FindTownFont.label1.font,
        selectedColorSet: [FindTownColor.white.color, FindTownColor.primary.color],
        nonSelectedColorSet: [FindTownColor.white.color, FindTownColor.grey4.color],
        strokeColor: .clear,
        topBottomInset: 8,
        cornerRadius: 0,
        imagePlacement: .top,
        imagePadding: 10
    )
}
