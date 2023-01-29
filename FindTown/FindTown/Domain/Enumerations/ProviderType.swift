//
//  ProviderType.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/26.
//

import Foundation

enum ProviderType {
    case kakao, apple
    
    var description: String {
        switch self {
        case .kakao:
            return "KAKAO"
        case .apple:
            return "APPLE"
        }
    }
}
