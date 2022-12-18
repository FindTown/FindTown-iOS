//
//  File.swift
//  
//
//  Created by 김성훈 on 2022/12/18.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func bind()
}

open class BaseViewModel: ViewModelType {
    struct Input { }
    struct Output { }

    
    public init() {
      self.bind()
    }
    
    func bind() { }
}
