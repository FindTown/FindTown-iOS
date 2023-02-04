//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/10.
//

import UIKit

public final class ImageButton: UIButton {
    
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -20, dy: -20).contains(point)
    }
    
    public init(imageText: String, tintColor: FindTownColor) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        configureUI(imageText: imageText, tintColor: tintColor)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(imageText: String, tintColor: FindTownColor) {
        let image = UIImage(named: imageText)
        image?.withTintColor(tintColor.color)
        
        setImage(image, for: .normal)
    }
}
