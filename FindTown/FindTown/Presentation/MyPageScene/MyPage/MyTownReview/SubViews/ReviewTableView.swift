//
//  ReviewTableView.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/01.
//

import UIKit

import FindTownUI

final class ReviewTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        separatorStyle = .none
        register(ReviewTableViewCell.self, forCellReuseIdentifier: ReviewTableViewCell.reuseIdentifier)
        contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
    }
}
