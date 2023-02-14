//
//  MCategory.swift
//  FindTown
//
//  Created by 이호영 on 2023/02/14.
//

import UIKit

protocol MCategory {
    var description: String { get }
    var image: UIImage? { get }
    var code: String { get }
}
