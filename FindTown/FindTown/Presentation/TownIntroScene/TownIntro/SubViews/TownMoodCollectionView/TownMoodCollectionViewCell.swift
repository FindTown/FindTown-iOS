//
//  TownMoodCollectionViewCell.swift
//  FindTown
//
//  Created by 장선영 on 2023/01/29.
//

import UIKit

import FindTownUI
import RxSwift

final class TownMoodCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
        
    // MARK: View
    
    private var townMoodLabel = FindTownLabel(text: "", font: .body4, textColor: .grey7)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(_ data: TownMood) {
        townMoodLabel.text = data.emojiDescription
        self.backgroundColor = data.color
    }
}

private extension TownMoodCollectionViewCell {
    
    func setupView() {
        self.layer.cornerRadius = 13
    }
    
    func setupLayout() {
        [townMoodLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            townMoodLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12.0),
            townMoodLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 6.0),
            townMoodLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            townMoodLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
    }
}
