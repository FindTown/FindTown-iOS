//
//  File.swift
//  
//
//  Created by 김성훈 on 2022/12/15.
//

import UIKit

public final class CheckButton: UIButton, Selectable {
    
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
        let image = UIImage(systemName: "checkmark.circle")
        let selectedImage = UIImage(systemName: "checkmark.circle.fill")
        
        setImage(image, for: .normal)
        setImage(selectedImage, for: .selected)
    }
}
