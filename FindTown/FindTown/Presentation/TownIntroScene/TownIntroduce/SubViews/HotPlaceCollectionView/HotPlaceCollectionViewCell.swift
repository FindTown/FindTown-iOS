//
//  HotPlaceCollectionViewCell.swift
//  FindTown
//
//  Created by 장선영 on 2023/01/29.
//

import UIKit
import FindTownUI

final class HotPlaceCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: View
    private let hotPlaceLabel = FindTownLabel(text: "",
                                              font: .label1,
                                              textColor: .grey4,
                                              textAlignment: .center)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(_ data: String) {
        hotPlaceLabel.text = "# \(data)"
    }
}

private extension HotPlaceCollectionViewCell {
    
    func setupView() {
        self.layer.cornerRadius = 16
        self.backgroundColor = FindTownColor.grey7.color
    }
    
    func setupLayout() {
        contentView.addSubview(hotPlaceLabel)
        hotPlaceLabel.translatesAutoresizingMaskIntoConstraints = false
       
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 34.0),
            hotPlaceLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8.0),
            hotPlaceLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 7.0),
            hotPlaceLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            hotPlaceLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
    }
}
