//
//  FilterBottomSheetType.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/08.
//

import UIKit

enum FilterSheetType {
    case Filter
    case Infra
    case Traffic
    
    var height: Double {
        switch self {
        case .Filter:
            return 0.87
        case .Infra:
            return 0.37
        case .Traffic:
            return 0.60
        }
    }
}
