//
//  TownMoodSelectHeaderView.swift
//  FindTown
//
//  Created by Nelly on 2023/06/05.
//

import UIKit

import FindTownUI

final class TownMoodSelectHeaderView: UICollectionReusableView {
  
  // MARK: Properties
  
  static var reuseIdentifier: String {
    return String(describing: self)
  }
  
  // MARK: View
  private let textLabel = FindTownLabel(text: "",
                                            font: .body1,
                                            textColor: .grey7,
                                            textAlignment: .center)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupCell(_ text: String) {
    textLabel.text = text
  }
}

private extension TownMoodSelectHeaderView {
  
  func setupView() {
    textLabel.textAlignment = .left
  }
  
  func setupLayout() {
    self.addSubview(textLabel)
    textLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      textLabel.topAnchor.constraint(equalTo: self.topAnchor),
      textLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
    ])
  }
}
