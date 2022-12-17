//
//  File.swift
//  
//
//  Created by 장선영 on 2022/12/16.
//

import Foundation
import UIKit

// SPM에 있는 Font 등록 메소드 - APP에서 반드시 호출해야함(현재는 AppDelegate에서 호출하고 있음)
public func registerFonts() {
    // 폰트 종류
    let fonts = [
        "Pretendard-Light.otf",
        "Pretendard-Medium.otf",
        "Pretendard-Regular.otf",
        "Pretendard-SemiBold.otf",
    ]
    
    // 폰트 등록하기
    for font in fonts {
        // UIFont extension 으로 파일로 불러와서 등록시키기
        UIFont.registerFont(bundle: Bundle.module, fontName: font)
    }
}

public extension UIFont {
    
    // HeadLine
    static let H1: UIFont = .init(name: "Pretendard-SemiBold", size: 32.0) ?? .systemFont(ofSize: 32.0)
    static let H2: UIFont = .init(name: "Pretendard-SemiBold", size: 28.0) ?? .systemFont(ofSize: 28.0)
    static let H3: UIFont = .init(name: "Pretendard-SemiBold", size: 24.0) ?? .systemFont(ofSize: 24.0)
    
    // Subtitle
    static let S1: UIFont = .init(name: "Pretendard-Medium", size: 22.0) ?? .systemFont(ofSize: 22.0)
    static let S2: UIFont = .init(name: "Pretendard-SemiBold", size: 20.0) ?? .systemFont(ofSize: 20.0)
    static let S3: UIFont = .init(name: "Pretendard-Medium", size: 20.0) ?? .systemFont(ofSize: 20.0)
    static let S4: UIFont = .init(name: "Pretendard-SemiBold", size: 18.0) ?? .systemFont(ofSize: 18.0)
    static let S5: UIFont = .init(name: "Pretendard-Medium", size: 18.0) ?? .systemFont(ofSize: 18.0)
    
    // Body
    static let B1: UIFont = .init(name: "Pretendard-Medium", size: 16.0) ?? .systemFont(ofSize: 16.0)
    static let B2: UIFont = .init(name: "Pretendard-Regular", size: 16.0) ?? .systemFont(ofSize: 16.0)
    static let B3: UIFont = .init(name: "Pretendard-Medium", size: 14.0) ?? .systemFont(ofSize: 14.0)
    static let B4: UIFont = .init(name: "Pretendard-Regular", size: 14.0) ?? .systemFont(ofSize: 14.0)
    
    // Label
    static let L1: UIFont = .init(name: "Pretendard-Regular", size: 14.0) ?? .systemFont(ofSize: 14.0)
    static let L2: UIFont = .init(name: "Pretendard-Medium", size: 12.0) ?? .systemFont(ofSize: 12.0)
    static let L3: UIFont = .init(name: "Pretendard-Light", size: 12.0) ?? .systemFont(ofSize: 12.0)
    static let L4: UIFont = .init(name: "Pretendard-Light", size: 11.0) ?? .systemFont(ofSize: 11.0)
    
    
    // 폰트 등록
    static func registerFont(bundle: Bundle, fontName: String) {

        guard let fontURL = bundle.path(forResource: fontName, ofType: nil) else {
            print("Couldn't find font \(fontName)")
            return
        }
        guard let fontData = NSData(contentsOfFile: fontURL) else {
            print("Couldn't load data \(fontName)")
            return
        }
        guard let fontDataProvider = CGDataProvider(data: fontData) else {
            print("Couldn't load data from the font  \(fontName)")
            return
        }
        guard let font = CGFont(fontDataProvider) else {
            print("Couldn't create font from data")
            return
        }

        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterGraphicsFont(font, &error)
        guard success else {
                print("Error registering font: maybe it was already registered.")
            return
        }
    }
}

