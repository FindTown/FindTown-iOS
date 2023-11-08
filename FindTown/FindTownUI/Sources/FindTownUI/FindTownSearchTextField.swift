//
//  File.swift
//  
//
//  Created by 장선영 on 2023/11/04.
//

import UIKit

public class FindTownSearchTextField: UITextField {
    
    private lazy var clearButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Icon_Delete"), for: .normal)
        button.addTarget(self, action: #selector(didTapClearButton), for: .touchUpInside)

        return button
    }()
    
    let insetX: CGFloat = 16
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var padding = super.leftViewRect(forBounds: bounds)
        padding.origin.x += 12
        
        return padding
    }
    
    public override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var padding = super.rightViewRect(forBounds: bounds)
        padding.origin.x -= 12

        return padding
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        return CGRect(x: 44, y: 0, width: bounds.size.width - (44 + 24 + 12), height: bounds.size.height)
    }
}

extension FindTownSearchTextField {
    
    @objc
    func didTapClearButton() {
        text?.removeAll()
        rightViewMode = .never
    }
    
    func setupView() {
        delegate = self
        
        let leftview = UIView(frame: CGRect(x: 12, y: 0, width: 32, height: 24))
        let imageView = UIImageView(image: UIImage(named: "Icon_search"))
        leftview.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(24)
        }
        
        self.leftView = leftview
        self.leftViewMode = .always
        self.rightView = clearButton
        self.rightViewMode = .whileEditing
        
        self.layer.cornerRadius = 18
        self.backgroundColor = FindTownColor.grey2.color
        self.font = FindTownFont.label1.font
        self.textColor = FindTownColor.grey7.color
        self.tintColor = FindTownColor.primary.color
    }
    
    func setupLayout() {
        self.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
    }
}

extension FindTownSearchTextField: UITextFieldDelegate {

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if text?.isEmpty ?? true {
            rightViewMode = .never
        }
    }
    
    public func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        /// newText: 새로 입력된 텍스트
        let newText = string.trimmingCharacters(in: .whitespacesAndNewlines)

        /// text: 기존에 입력되었던 text
        /// predictRange: 입력으로 예상되는 text의 range값 추측 > range값을 알면 기존 문자열에 새로운 문자를 위치에 알맞게 추가 가능
        guard let text = textField.text, let predictRange = Range(range, in: text) else { return true }

        /// predictedText: 기존에 입력되었던 text에 새로 입력된 newText를 붙여서, 현재까지 입력된 전체 텍스트
        let predictedText = text.replacingCharacters(in: predictRange, with: newText)
            .trimmingCharacters(in: .whitespacesAndNewlines)

        if predictedText.isEmpty {
            rightViewMode = .never
        } else {
            rightViewMode = .whileEditing
        }

        return true
    }
}
