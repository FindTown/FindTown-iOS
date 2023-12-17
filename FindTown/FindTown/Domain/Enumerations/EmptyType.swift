//
//  EmptyType.swift
//  FindTown
//
//  Created by 장선영 on 2023/12/17.
//

import Foundation

enum EmptyType {
    case emptyFavorite
    case emptyPlace
    
    var title: String {
        switch self {
        case .emptyFavorite:
            return "찜한 동네가 아직 없어요."
        case .emptyPlace:
            return "아직 제보된 장소가 없어요."
        }
    }
    
    var subTitle: String {
        switch self {
        case .emptyFavorite:
            return "나에게 맞는 동네를 찾아서 찜해보세요!"
        case .emptyPlace:
            return "우리 동네에서 추천할만한 장소가 있다면 \n알려주세요!"
        }
    }
    
    var iconImage: UIImage {
        switch self {
        case .emptyFavorite:
            return UIImage(named: "emptyIcon") ?? UIImage()
        case .emptyPlace:
            return UIImage(named: "ic_no place") ?? UIImage()
        }
    }
    
    var isButtonHidden: Bool {
        switch self {
        case .emptyFavorite:
            return false
        case .emptyPlace:
            return true
        }
    }
}
