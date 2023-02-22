//
//  File.swift
//  
//
//  Created by 김성훈 on 2023/01/07.
//

import UIKit

public final class CheckBox: UIButton {
    
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
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .light)
        let selectedImageConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .light)
        let image = UIImage(named: "checkBox", in: .module, compatibleWith: nil)?.withConfiguration(imageConfiguration)
        let selectedImage = UIImage(named: "checkBoxFill", in: .module, compatibleWith: nil)?.withConfiguration(selectedImageConfiguration)
        
        setImage(image, for: .normal)
        setImage(selectedImage, for: .selected)
    }
}

