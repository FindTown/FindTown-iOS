//
//  ViewModelType.swift
//  FindTown
//
//  Created by 김성훈 on 2022/12/04.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func bind()
}
