//
//  InfraIconStackView.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/16.
//

import UIKit

import FindTownUI
import FindTownCore
import RxCocoa
import RxSwift

final class InfraIconStackView: UIStackView {
    
    // MARK: - Properties
    
    weak var delegate: InfraIconStackViewDelegate?
    
    // MARK: - Views
    
    private let shopFilterIcon = FTButton(style: .icon)
    
    private let hospitalFilterIcon = FTButton(style: .icon)
    
    private let healthFilterIcon = FTButton(style: .icon)
    
    private let natureFilterIcon = FTButton(style: .icon)
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addView()
        setLayout()
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addView() {
        [shopFilterIcon, hospitalFilterIcon, healthFilterIcon, natureFilterIcon].forEach {
            self.addArrangedSubview($0)
            $0.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        }
    }
    
    func setLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .horizontal
        self.distribution = .equalSpacing
    }
    
    func setupView() {
        shopFilterIcon.setTitle("편의시설", for: .normal)
        shopFilterIcon.setImage(UIImage(named: "shop")?.withRenderingMode(.alwaysTemplate)
                                ?? UIImage(), for: .normal)
        
        hospitalFilterIcon.setTitle("의료", for: .normal)
        hospitalFilterIcon.setImage(UIImage(named: "hospital")?.withRenderingMode(.alwaysTemplate)
                                    ?? UIImage(), for: .normal)
        
        healthFilterIcon.setTitle("운동", for: .normal)
        healthFilterIcon.setImage(UIImage(named: "health")?.withRenderingMode(.alwaysTemplate)
                                  ?? UIImage(), for: .normal)
        
        natureFilterIcon.setTitle("자연", for: .normal)
        natureFilterIcon.setImage(UIImage(named: "nature")?.withRenderingMode(.alwaysTemplate)
                                  ?? UIImage(), for: .normal)
    }
    
    @objc func buttonAction(button: FTButton) {
        guard let buttonTitle = button.titleLabel?.text else { return }
        delegate?.didSelectInfraIcon?(value: buttonTitle)
        changedButton(button: button)
    }
    
    func changedButton(button: FTButton) {
        [shopFilterIcon, hospitalFilterIcon, healthFilterIcon, natureFilterIcon].forEach {
            $0.isSelected = false
        }
        button.isSelected = true
    }
}

@objc protocol InfraIconStackViewDelegate: AnyObject {
    @objc optional func didSelectInfraIcon(value: String)
}

private class InfraIconDelegateProxy: DelegateProxy<InfraIconStackView, InfraIconStackViewDelegate>
, DelegateProxyType, InfraIconStackViewDelegate
{
    static func registerKnownImplementations() {
        self.register { (infraIconStackView) -> InfraIconDelegateProxy in
            InfraIconDelegateProxy(parentObject: infraIconStackView, delegateProxy: self)
        }
    }
    
    static func currentDelegate(for object: InfraIconStackView) -> InfraIconStackViewDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: InfraIconStackViewDelegate?,
                                   to object: InfraIconStackView)
    {
        object.delegate = delegate
    }
}

extension Reactive where Base: InfraIconStackView {
    
    var delegate : DelegateProxy<InfraIconStackView, InfraIconStackViewDelegate> {
        return InfraIconDelegateProxy.proxy(for: self.base)
    }
    
    var didSelectInfraIcon: Observable<String?> {
        return delegate.methodInvoked(#selector(InfraIconStackViewDelegate.didSelectInfraIcon(value:)))
            .map { dropDownData in
                let index = dropDownData.first as! String
                return index
            }
    }
}
