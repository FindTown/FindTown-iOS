//
//  TownMoodSelectCollectionViewCell.swift
//  FindTown
//
//  Created by Nelly on 2023/06/05.
//

import UIKit

import FindTownUI

final class TownMoodSelectCollectionViewCell: UICollectionViewCell {
  
  // MARK: Properties
  
  static var reuseIdentifier: String {
    return String(describing: self)
  }
  
  // MARK: View
  private let textLabel = FindTownLabel(text: "",
                                        font: .body4,
                                        textColor: .grey5,
                                        textAlignment: .center)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    setupLayout()
  }
  
  override var isSelected: Bool {
      didSet {
          if isSelected {
            contentView.layer.borderColor = FindTownColor.primary.color.cgColor
            textLabel.textColor = FindTownColor.primary.color
          } else {
            contentView.layer.borderColor = FindTownColor.grey3.color.cgColor
            textLabel.textColor = FindTownColor.grey5.color
          }
      }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupCell(_ text: String) {
    textLabel.text = text
  }
}

private extension TownMoodSelectCollectionViewCell {
  
  func setupView() {
    contentView.layer.cornerRadius = 14
    contentView.layer.borderWidth = 1
    contentView.layer.borderColor = FindTownColor.grey3.color.cgColor
  }
  
  func setupLayout() {
    contentView.addSubview(textLabel)
    textLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      textLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12),
      textLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 6),
      textLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -6),
      textLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12)
    ])
  }
}

