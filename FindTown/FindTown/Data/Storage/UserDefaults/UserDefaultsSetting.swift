//
//  GlobalSettings.swift
//  FindTown
//
//  Created by 장선영 on 2023/02/17.
//

import Foundation

enum UserDefaultsSetting {
    
    @UserDefaultsWrapper(key: "isAnonymous", defaultValue: true)
    static var isAnonymous
}
