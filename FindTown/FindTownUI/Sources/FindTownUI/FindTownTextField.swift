//
//  File.swift
//  
//
//  Created by 장선영 on 2022/12/21.
//

import Foundation
import UIKit

/// FindTownTF의 status 타입 정의
public enum FindTownTextFieldStatus {
    case unfocused
    case error
    case focused
}

/// FindTown 프로젝트에서 사용되는 Custom TextField
public class FindTownTextField: UITextField {
    
    /// TextField의 좌, 우 inset
    var insetX: CGFloat = 16
    
    /// FindTownTextFieldStatus에 따라 TextField layer의 색상 변경
    public var status: FindTownTextFieldStatus = .unfocused {
        didSet {
            switch status {
            case .unfocused:
                self.layer.borderColor = FindTownColor.grey4.color.cgColor
            case .error:
                self.layer.borderColor = FindTownColor.semantic.color.cgColor
            case .focused:
                self.layer.borderColor = FindTownColor.grey6.color.cgColor
            }
        }
    }
    
    /// clearButtonMode = .whileEditing 로 default 설정
    public init(clearButtonMode: UITextField.ViewMode = .whileEditing) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.clearButtonMode = clearButtonMode
        configureUI()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setTextFieldStatus()
    }
}

// MARK: TextField 내부 inset 설정

extension FindTownTextField {
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: 0.0)
    }

    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: 0.0)
    }
    
    public override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let buttonWidth = 18.0
        let buttonX = self.bounds.width - (buttonWidth + insetX)
        return CGRect(x: buttonX, y: 13.0, width: buttonWidth, height: buttonWidth)
    }
}

// MARK: FindTownTextField UI 설정

private extension FindTownTextField {
    
    func configureUI() {
        self.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        
        self.font = FindTownFont.label1.font
        self.textColor = FindTownColor.grey7.color
        self.tintColor = FindTownColor.primary.color
        self.layer.cornerRadius = 8.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = FindTownColor.grey4.color.cgColor
    }
    
    func setTextFieldStatus() {
        if self.isFirstResponder {
            self.status = .focused
        } else {
            self.status = .unfocused
        }
    }
}
