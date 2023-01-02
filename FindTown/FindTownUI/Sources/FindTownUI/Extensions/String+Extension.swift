//
//  File.swift
//  
//
//  Created by 김성훈 on 2023/01/02.
//

import Foundation

extension String {
    
    /// 닉네임에 알파벳, 한글, 특수문자 ( ! . @ #) 말고 다른거 들어가있나 체크
    public func isValidNickname() -> Bool {
        let allowedCharacters = "^[a-zA-Z0-9!@.#|\u{1100}-\u{11FF}\u{3130}-\u{318F}\u{A960}-\u{A97F}\u{AC00}-\u{D7AF}]*$"
        let nicknameTest = NSPredicate(format: "SELF MATCHES %@", allowedCharacters)
        
        return nicknameTest.evaluate(with: self) && self != ""
    }
}
