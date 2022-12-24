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
    case focused   /// 작성 중
    case unfocused /// 작성 중 아님
    case error     /// 텍스트가 조건을 만족하지 않음
}

/// FindTown 프로젝트에서 사용되는 Custom TextField
public class FindTownTextField: UITextField {
    
    /// TextField의 error 케이스에 대한 변수
    /// isError = true: 텍스트가 조건을 만족하지 않음/ isError = false: 텍스트가 조건을 만족 or error 케이스를 사용하지 않는 경우
    public var isError = false
    /// TextField의 좌, 우 inset
    let insetX: CGFloat = 16
    /// clearButton의 width,height 길이
    let clearButtonWidth = 18.0
    
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
    
    /// clearButtonMode = .whileEditing으로 default 설정
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
        
        if clearButtonMode == .never {
            return CGRect(x: insetX, y: 0, width: bounds.size.width - (insetX), height: bounds.size.height)
        } else {
            return CGRect(x: insetX, y: 0, width: bounds.size.width - (clearButtonWidth + insetX*2), height: bounds.size.height)
        }
    }
    
    public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        
        if clearButtonMode == .never {
            return CGRect(x: insetX, y: 0, width: bounds.size.width - (insetX), height: bounds.size.height)
        } else {
            return CGRect(x: insetX, y: 0, width: bounds.size.width - (clearButtonWidth + insetX*2), height: bounds.size.height)
        }
    }
    
    public override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let buttonX = self.bounds.size.width - (clearButtonWidth + insetX)
        return CGRect(x: buttonX, y: 13.0, width: clearButtonWidth, height: clearButtonWidth)
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
        if self.isFirstResponder && self.isError {
            self.status = .error
        } else if self.isFirstResponder && self.isError == false {
            self.status = .focused
        } else {
            self.status = .unfocused
        }
    }
}
