//
//  PlaceTableView.swift
//  FindTown
//
//  Created by 장선영 on 2023/12/03.
//

import UIKit

final class PlaceTableView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
    
    override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    private func setupView() {
        self.separatorStyle = .none
        self.rowHeight = UITableView.automaticDimension
        self.isScrollEnabled = false
        register(PlaceTableViewCell.self,
                 forCellReuseIdentifier: PlaceTableViewCell.reuseIdentifier)
//        contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
    }
}
