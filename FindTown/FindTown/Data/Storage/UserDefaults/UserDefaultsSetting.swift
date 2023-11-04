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

    @UserDefaultsWrapper(key: "SearchFirstEnter", defaultValue: false)
    static var isSearchFirstEnter
    
    @UserDefaultsWrapper(key: "searchedDongList", defaultValue: [Search]())
    static var searchedDongList
}
