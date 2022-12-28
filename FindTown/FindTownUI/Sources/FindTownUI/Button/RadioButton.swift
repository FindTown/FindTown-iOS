//
//  File.swift
//  
//
//  Created by 김성훈 on 2022/12/15.
//

import UIKit

public final class RadioButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        changesSelectionAsPrimaryAction = true
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        let image = UIImage(systemName: "circle")
        let selectedImage = UIImage(systemName: "circle.circle.fill")
        
        setImage(image, for: .normal)
        setImage(selectedImage, for: .selected)
    }
}
