//
//  UserDefaultUtil.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/10.
//

import Foundation

struct UserDefaultUtil {
    
    private let ACCESS_TOKEN = "ACCESS_TOKEN"
    private let SIGNIN_TYPE = "SIGNIN_TYPE"
    private let USER_NICKNAME = "USER_NICKNAME"
    
    let instance: UserDefaults
    
    init() {
        instance = UserDefaults.standard
    }
    
    var accessToken: String {
        get {
            return self.instance.string(forKey: ACCESS_TOKEN) ?? ""
        }
        set {
            self.instance.set(newValue, forKey: ACCESS_TOKEN)
        }
    }
    
    var signinType: String {
        get {
            return self.instance.string(forKey: SIGNIN_TYPE) ?? ""
        }
        set {
            self.instance.set(newValue, forKey: SIGNIN_TYPE)
        }
    }

    var userNickname: String {
        get {
            return self.instance.string(forKey: USER_NICKNAME) ?? ""
        }
        set {
            self.instance.set(newValue, forKey: USER_NICKNAME)
        }
    }
    
    func clear() {
        self.instance.removeObject(forKey: ACCESS_TOKEN)
        self.instance.removeObject(forKey: SIGNIN_TYPE)
        self.instance.removeObject(forKey: USER_NICKNAME)
    }
}
