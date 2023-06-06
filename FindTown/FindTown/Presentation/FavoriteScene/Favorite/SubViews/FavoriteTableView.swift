//
//  FavoriteDataTableView.swift
//  FindTown
//
//  Created by 장선영 on 2023/01/18.
//

import Foundation
import UIKit
import FindTownUI

/// 찜한 동네리스트를 보여주는 tableView
final class FavoriteTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension FavoriteTableView {
    
    func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.separatorStyle = .none
        self.backgroundColor = .clear
        self.showsVerticalScrollIndicator = false
        self.automaticallyAdjustsScrollIndicatorInsets = false
        self.rowHeight = 174 + 16
        self.tableHeaderView = returnTableHeaderView()
        self.register(TownTableViewCell.self,
                      forCellReuseIdentifier: TownTableViewCell.reuseIdentifier)
    }
    
    func returnTableHeaderView() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: self.bounds.width,
                                              height: 60.0))
        
        let titleLabel = FindTownLabel(text: "내가 찜한 동네",
                                       font: .subtitle2,
                                       textColor: .grey6,
                                       textAlignment: .left)
        
        headerView.backgroundColor = .clear
        headerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor,
                                                constant: 16.0),
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor,
                                            constant: 24.0)
        ])
        return headerView
    }
}
