//
//  File.swift
//  
//
//  Created by 김성훈 on 2022/12/18.
//

import UIKit
import RxSwift

open class BaseViewController: UIViewController {
    
    public let disposeBag = DisposeBag()
    
    private let scrollView = UIScrollView()
    public let contentView = UIView()
    public let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        //        hideKeyboard()
        
        addView()
        setupView()
        setLayout()
        
        bindViewModel()
        //        setUpNotification()
    }
    
    open func addView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
    }
    
    open func setupView() {}
    
    open func setLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: 0),
            
            contentView.topAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: self.scrollView.frameLayoutGuide.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    open func bindViewModel() {}
    
    // 빈 공간만 탭 키보드 내리기
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    private func setUpNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
}

extension BaseViewController {
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
              var keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                  return
              }
        keyboardFrame = self.contentView.convert(keyboardFrame, from: nil)
        var contentInset = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 40
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = self.scrollView.contentInset
    }

    @objc private func keyboardWillHide(_ notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = self.scrollView.contentInset
    }
}
