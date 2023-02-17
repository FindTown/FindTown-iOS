//
//  UserDefaultsWrapper.swift
//  FindTown
//
//  Created by 장선영 on 2023/02/17.
//

import Foundation

@propertyWrapper
struct UserDefaultsWrapper<T> {
    private let key: String
    private let defaultValue: T
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
