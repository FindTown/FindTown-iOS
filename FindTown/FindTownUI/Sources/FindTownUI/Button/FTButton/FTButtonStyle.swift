//
//  File.swift
//  
//
//  Created by 김성훈 on 2022/12/15.
//

import UIKit

private let tempFontSize = 16.0
private let tempWhiteColor = UIColor.white
private let tempBlackColor = UIColor.black
private let tempRedColor = UIColor.red
private let tempGrayColor = UIColor.gray

public struct FTButtonStyle {
    let configu: UIButton.Configuration
    let titleFont: UIFont
    let selectedBackgroundColor: UIColor
    let nonSelectedBackgroundColor: UIColor
    let selectedBaseColor: UIColor
    let nonSelectedBaseColor: UIColor
    let inset: CGFloat
    var imagePlacement: NSDirectionalRectEdge = .all
    let imagePadding: CGFloat
    let cornerRadius: CGFloat
    var isShadow: Bool = false
    var strokeWidth: Double = 1
}

extension FTButtonStyle {
    public static let largeType = FTButtonStyle (
        configu: .tinted(),
        titleFont: .systemFont(ofSize: tempFontSize),
        selectedBackgroundColor: tempWhiteColor,
        nonSelectedBackgroundColor: tempWhiteColor,
        selectedBaseColor: tempRedColor,
        nonSelectedBaseColor: tempGrayColor,
        inset: 0,
        imagePadding: 0,
        cornerRadius: 10
    )
    
    public static let mediumBackgroundColorType = FTButtonStyle (
        configu: .filled(),
        titleFont: .systemFont(ofSize: tempFontSize),
        selectedBackgroundColor: tempRedColor,
        nonSelectedBackgroundColor: tempRedColor,
        selectedBaseColor: tempWhiteColor,
        nonSelectedBaseColor: tempWhiteColor,
        inset: 50,
        imagePadding: 0,
        cornerRadius: 10
    )
    
    public static let mediumOpacityBackgroundColorType = FTButtonStyle (
        configu: .tinted(),
        titleFont: .systemFont(ofSize: tempFontSize),
        selectedBackgroundColor: tempRedColor.withAlphaComponent(0.3),
        nonSelectedBackgroundColor: tempRedColor.withAlphaComponent(0.3),
        selectedBaseColor: tempRedColor,
        nonSelectedBaseColor: tempRedColor,
        inset: 50,
        imagePadding: 0,
        cornerRadius: 10
    )
    
    public static let mediumRadiusColorType = FTButtonStyle (
        configu: .tinted(),
        titleFont: .systemFont(ofSize: tempFontSize),
        selectedBackgroundColor: tempWhiteColor,
        nonSelectedBackgroundColor: tempWhiteColor,
        selectedBaseColor: tempRedColor,
        nonSelectedBaseColor: tempRedColor,
        inset: 50,
        imagePadding: 0,
        cornerRadius: 10
    )
    
    public static let smallType = FTButtonStyle (
        configu: .tinted(),
        titleFont: .systemFont(ofSize: tempFontSize),
        selectedBackgroundColor: tempWhiteColor,
        nonSelectedBackgroundColor: tempWhiteColor,
        selectedBaseColor: tempRedColor,
        nonSelectedBaseColor: tempGrayColor,
        inset: 40,
        imagePadding: 0,
        cornerRadius: 10
    )
    
    public static let xSmallType = FTButtonStyle (
        configu: .tinted(),
        titleFont: .systemFont(ofSize: tempFontSize),
        selectedBackgroundColor: tempWhiteColor,
        nonSelectedBackgroundColor: tempWhiteColor,
        selectedBaseColor: tempRedColor,
        nonSelectedBaseColor: tempGrayColor,
        inset: 25,
        imagePadding: 0,
        cornerRadius: 10
    )
    
    public static let xxSmallType = FTButtonStyle (
        configu: .tinted(),
        titleFont: .systemFont(ofSize: tempFontSize),
        selectedBackgroundColor: tempWhiteColor,
        nonSelectedBackgroundColor: tempWhiteColor,
        selectedBaseColor: tempRedColor,
        nonSelectedBaseColor: tempGrayColor,
        inset: 10,
        imagePadding: 0,
        cornerRadius: 10
    )
    
    public static let buttonFilterClipType = FTButtonStyle (
        configu: .tinted(),
        titleFont: .systemFont(ofSize: tempFontSize),
        selectedBackgroundColor: tempWhiteColor,
        nonSelectedBackgroundColor: tempWhiteColor,
        selectedBaseColor: tempRedColor,
        nonSelectedBaseColor: tempGrayColor,
        inset: 20,
        imagePlacement: .trailing,
        imagePadding: 5,
        cornerRadius: 30
    )
    
    public static let iconFilterClipType = FTButtonStyle (
        configu: .filled(),
        titleFont: .systemFont(ofSize: tempFontSize),
        selectedBackgroundColor: tempRedColor,
        nonSelectedBackgroundColor: tempWhiteColor,
        selectedBaseColor: tempWhiteColor,
        nonSelectedBaseColor: tempGrayColor,
        inset: 20,
        imagePlacement: .leading,
        imagePadding: 5,
        cornerRadius: 30,
        isShadow: true
    )
    
    public static let roundButtonType = FTButtonStyle (
        configu: .filled(),
        titleFont: .systemFont(ofSize: tempFontSize),
        selectedBackgroundColor: tempWhiteColor,
        nonSelectedBackgroundColor: tempBlackColor,
        selectedBaseColor: tempBlackColor,
        nonSelectedBaseColor: tempWhiteColor,
        inset: 20,
        imagePlacement: .leading,
        imagePadding: 5,
        cornerRadius: 30,
        isShadow: true
    )
    
    public static let iconButtonType = FTButtonStyle (
        configu: .tinted(),
        titleFont: .systemFont(ofSize: 20),
        selectedBackgroundColor: tempWhiteColor,
        nonSelectedBackgroundColor: tempWhiteColor,
        selectedBaseColor: tempRedColor,
        nonSelectedBaseColor: tempGrayColor,
        inset: 20,
        imagePlacement: .top,
        imagePadding: 10,
        cornerRadius: 0,
        strokeWidth: 0.0
    )
}
