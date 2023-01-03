//
//  MapData.swift
//  FindTown
//
//  Created by 장선영 on 2023/01/02.
//

import Foundation
import UIKit

//struct MapData {
//    let category
//}

enum MapCategory {
    case infra
    case theme
}

struct MapData {
    let categories: [Category]
}

struct Category {
    let image: UIImage
    let title: String
    let detailCategories: [DetailCategory]
}

struct DetailCategory {
    let color: UIColor
    let detailTitle: String
    /// let points
}
