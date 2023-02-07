//
//  TownTableView.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/13.
//

import UIKit

import FindTownUI

final class TownTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = FindTownColor.white.color
        separatorStyle = .none
        register(TownTableViewCell.self, forCellReuseIdentifier: TownTableViewCell.reuseIdentifier)
    }
}
