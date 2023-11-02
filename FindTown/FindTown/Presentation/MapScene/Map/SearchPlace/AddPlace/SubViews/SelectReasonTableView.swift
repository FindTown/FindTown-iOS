//
//  SelectReasonTableView.swift
//  FindTown
//
//  Created by 장선영 on 2023/11/02.
//

import UIKit

final class SelectReasonTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        separatorStyle = .none
        isScrollEnabled = false
        allowsMultipleSelection = true
        register(
            SelectReasonTableViewCell.self,
            forCellReuseIdentifier: SelectReasonTableViewCell.reuseIdentifier)
        self.rowHeight = 32 + 16
    }
}
