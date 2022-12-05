//
//  BaseViewModel.swift
//  FindTown
//
//  Created by 김성훈 on 2022/12/04.
//

import Foundation
import RxSwift

class BaseViewModel: ViewModelType {
    struct Input { }
    struct Output { }

    let disposeBag = DisposeBag()
    
    init() {
      self.bind()
    }
    
    func bind() {}
}
