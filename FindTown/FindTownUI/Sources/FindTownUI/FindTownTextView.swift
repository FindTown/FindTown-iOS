//
//  File.swift
//  
//
//  Created by 장선영 on 2023/11/02.
//

import UIKit
import SnapKit

public class FindTownTextView: UIView {
    
    private let textView = UITextView()
    private let textCountLabel = FindTownLabel(text: "0/100", font: .label3, textColor: .grey6)
    private var placeHolder: String?
    private var maximumText: Int
    
    public init(placeholder: String?, maximumText: Int) {
        self.placeHolder = placeholder
        self.maximumText = maximumText
        
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupView()
        addView()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FindTownTextView {
    func setupView() {
        self.textView.delegate = self
        self.textView.text = placeHolder
        self.textView.textColor = FindTownColor.grey5.color
        self.textView.tintColor = FindTownColor.primary.color
        self.textView.textContainerInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16);
        self.textView.font = FindTownFont.label1.font
        
        self.textView.layer.cornerRadius = 8.0
        self.textView.layer.borderWidth = 1.0
        self.textView.layer.borderColor = FindTownColor.grey4.color.cgColor
    }
    
    func addView() {
        [textView, textCountLabel].forEach {
            self.addSubview($0)
        }
    }
    
    func setLayout() {
        textView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(164)
        }
        
        textCountLabel.snp.makeConstraints {
            $0.trailing.equalTo(textView)
            $0.top.equalTo(textView.snp.bottom).offset(4)
            $0.bottom.equalToSuperview()
        }
    }
}

extension FindTownTextView: UITextViewDelegate {
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let textViewText = textView.text else { return false }
        let currentText = textViewText
        guard let stringRange = Range(range, in: currentText) else { return false }
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        textCountLabel.text = "\(changedText.count)/\(maximumText)"
        
        return changedText.count < maximumText
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == FindTownColor.grey5.color {
            textView.text = nil
            textView.textColor = FindTownColor.grey7.color
            textView.layer.borderColor = FindTownColor.grey6.color.cgColor
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeHolder
            textView.textColor = FindTownColor.grey5.color
            textView.layer.borderColor = FindTownColor.grey4.color.cgColor
        }
    }
}
