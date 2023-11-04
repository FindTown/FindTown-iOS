//
//  PlaceTableView.swift
//  FindTown
//
//  Created by 장선영 on 2023/10/31.
//

import UIKit
import SnapKit

final class SearchedPlaceTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchedPlaceTableView {
    
    func setView() {
        self.separatorStyle = .none
        self.backgroundColor = .white
        self.showsVerticalScrollIndicator = false
        self.automaticallyAdjustsScrollIndicatorInsets = false
        self.rowHeight = 86
        self.register(SearchedPlaceTableViewCell.self,
                      forCellReuseIdentifier: SearchedPlaceTableViewCell.reuseIdentifier)
    }
}
