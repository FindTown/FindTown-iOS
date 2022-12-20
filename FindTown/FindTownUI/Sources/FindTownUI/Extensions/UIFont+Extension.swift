//
//  File.swift
//  
//
//  Created by 장선영 on 2022/12/16.
//

import Foundation
import UIKit

// Font 등록 메서드 - APP에서 반드시 호출해야함(AppDelegate에서 호출하고 있음)
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

extension UIFont {
    
    // Pretendard 타입 UIFont 반환 메서드
    static func pretendard(type: PretendardType, size: CGFloat) -> UIFont {
        // Pretendard 폰트가 없는 경우 systemFont를 반환하도록 함
        guard let font = UIFont(name: type.name, size: size) else { return UIFont.systemFont(ofSize: size) }
        return font
    }

    // 폰트 등록 메서드
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
