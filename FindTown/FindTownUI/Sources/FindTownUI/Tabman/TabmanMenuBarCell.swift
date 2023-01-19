//
//  File.swift
//  
//
//  Created by 김성훈 on 2023/01/18.
//

import UIKit

public class TabmanMenuBarCell: UICollectionViewCell {
    
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    var title = FindTownLabel(text: "", font: .subtitle4, textColor: FindTownColor.grey3)
    
    public override var isSelected: Bool {
        didSet{
            self.title.textColor = isSelected ? FindTownColor.black.color : FindTownColor.grey3.color
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(title)
        title.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        title.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
