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
    let configuration: UIButton.Configuration
    let titleFont: UIFont
    let backgroundColor: UIColor
    let foregroundColor: UIColor
    let inset: CGFloat
    let cornerRadius: CGFloat
    var imagePlacement: NSDirectionalRectEdge = .all
    var imagePadding: CGFloat = 0.0
    var isShadow: Bool = false
    var strokeWidth: Double = 1
}

extension FTButtonStyle {
    public static let largeSelectedType = FTButtonStyle (
        configuration: .tinted(),
        titleFont: .systemFont(ofSize: tempFontSize),
        backgroundColor: tempWhiteColor,
        foregroundColor: tempRedColor,
        inset: 0,
        cornerRadius: 10
    )
    
    public static let largeNonSelectedType = FTButtonStyle (
        configuration: .tinted(),
        titleFont: .systemFont(ofSize: tempFontSize),
        backgroundColor: tempWhiteColor,
        foregroundColor: tempGrayColor,
        inset: 0,
        cornerRadius: 10
    )
    
    public static let mediumBackgroundColorType = FTButtonStyle (
        configuration: .filled(),
        titleFont: .systemFont(ofSize: tempFontSize),
        backgroundColor: tempRedColor,
        foregroundColor: tempWhiteColor,
        inset: 50,
        cornerRadius: 10
    )

    public static let mediumOpacityBackgroundColorType = FTButtonStyle (
        configuration: .tinted(),
        titleFont: .systemFont(ofSize: tempFontSize),
        backgroundColor: tempRedColor.withAlphaComponent(0.3),
        foregroundColor: tempRedColor,
        inset: 50,
        cornerRadius: 10,
        strokeWidth: 0.0
    )

    public static let mediumRadiusColorType = FTButtonStyle (
        configuration: .tinted(),
        titleFont: .systemFont(ofSize: tempFontSize),
        backgroundColor: tempWhiteColor,
        foregroundColor: tempRedColor,
        inset: 50,
        cornerRadius: 10
    )

    public static let smallSelectedType = FTButtonStyle (
        configuration: .tinted(),
        titleFont: .systemFont(ofSize: tempFontSize),
        backgroundColor: tempWhiteColor,
        foregroundColor: tempRedColor,
        inset: 40,
        cornerRadius: 10
    )
    
    public static let smallNonSelectedType = FTButtonStyle (
        configuration: .tinted(),
        titleFont: .systemFont(ofSize: tempFontSize),
        backgroundColor: tempWhiteColor,
        foregroundColor: tempGrayColor,
        inset: 40,
        cornerRadius: 10
    )

    public static let xSmallSelectedType = FTButtonStyle (
        configuration: .tinted(),
        titleFont: .systemFont(ofSize: tempFontSize),
        backgroundColor: tempWhiteColor,
        foregroundColor: tempRedColor,
        inset: 25,
        cornerRadius: 10
    )
    
    public static let xSmallNonSelectedType = FTButtonStyle (
        configuration: .tinted(),
        titleFont: .systemFont(ofSize: tempFontSize),
        backgroundColor: tempWhiteColor,
        foregroundColor: tempGrayColor,
        inset: 25,
        cornerRadius: 10
    )
    
    public static let xxSmallSelectedType = FTButtonStyle (
        configuration: .tinted(),
        titleFont: .systemFont(ofSize: tempFontSize),
        backgroundColor: tempWhiteColor,
        foregroundColor: tempRedColor,
        inset: 10,
        cornerRadius: 10
    )
    
    public static let xxSmallNonSelectedType = FTButtonStyle (
        configuration: .tinted(),
        titleFont: .systemFont(ofSize: tempFontSize),
        backgroundColor: tempWhiteColor,
        foregroundColor: tempGrayColor,
        inset: 10,
        cornerRadius: 10
    )

    public static let buttonFilterChipSelectedType = FTButtonStyle (
        configuration: .tinted(),
        titleFont: .systemFont(ofSize: tempFontSize),
        backgroundColor: tempWhiteColor,
        foregroundColor: tempRedColor,
        inset: 20,
        cornerRadius: 30,
        imagePlacement: .trailing,
        imagePadding: 5
    )
    
    public static let buttonFilterChipNonSelectedType = FTButtonStyle (
        configuration: .tinted(),
        titleFont: .systemFont(ofSize: tempFontSize),
        backgroundColor: tempWhiteColor,
        foregroundColor: tempGrayColor,
        inset: 20,
        cornerRadius: 30,
        imagePlacement: .trailing,
        imagePadding: 5
    )

    public static let iconFilterChipSelectedType = FTButtonStyle (
        configuration: .filled(),
        titleFont: .systemFont(ofSize: tempFontSize),
        backgroundColor: tempRedColor,
        foregroundColor: tempWhiteColor,
        inset: 20,
        cornerRadius: 30,
        imagePlacement: .leading,
        imagePadding: 5,
        isShadow: true
    )
    
    public static let iconFilterChipNonSelectedType = FTButtonStyle (
        configuration: .filled(),
        titleFont: .systemFont(ofSize: tempFontSize),
        backgroundColor: tempWhiteColor,
        foregroundColor: tempGrayColor,
        inset: 20,
        cornerRadius: 30,
        imagePlacement: .leading,
        imagePadding: 5,
        isShadow: true
    )

    public static let roundSelectedType = FTButtonStyle (
        configuration: .filled(),
        titleFont: .systemFont(ofSize: tempFontSize),
        backgroundColor: tempWhiteColor,
        foregroundColor: tempBlackColor,
        inset: 20,
        cornerRadius: 30,
        imagePlacement: .leading,
        imagePadding: 5,
        isShadow: true
    )
    
    public static let roundNonSelectedType = FTButtonStyle (
        configuration: .filled(),
        titleFont: .systemFont(ofSize: tempFontSize),
        backgroundColor: tempBlackColor,
        foregroundColor: tempWhiteColor,
        inset: 20,
        cornerRadius: 30,
        imagePlacement: .leading,
        imagePadding: 5,
        isShadow: true
    )

    public static let iconButtonSelectedType = FTButtonStyle (
        configuration: .tinted(),
        titleFont: .systemFont(ofSize: 20),
        backgroundColor: tempWhiteColor,
        foregroundColor: tempRedColor,
        inset: 20,
        cornerRadius: 0,
        imagePlacement: .top,
        imagePadding: 10,
        strokeWidth: 0.0
    )
    
    public static let iconButtonNonSelectedType = FTButtonStyle (
        configuration: .tinted(),
        titleFont: .systemFont(ofSize: 20),
        backgroundColor: tempWhiteColor,
        foregroundColor: tempGrayColor,
        inset: 20,
        cornerRadius: 0,
        imagePlacement: .top,
        imagePadding: 10,
        strokeWidth: 0.0
    )
}
