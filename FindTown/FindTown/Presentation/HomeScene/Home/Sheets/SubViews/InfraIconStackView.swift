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
        shopFilterIcon.setSelectedImage(normalImage: UIImage(named: "shop") ?? UIImage(),
                                        selectedImage: UIImage(named: "shop_selected") ?? UIImage())
        
        hospitalFilterIcon.setTitle("의료", for: .normal)
        hospitalFilterIcon.setSelectedImage(normalImage: UIImage(named: "hospital") ?? UIImage(),
                                            selectedImage: UIImage(named: "hospital_selected") ?? UIImage())
        
        healthFilterIcon.setTitle("운동", for: .normal)
        healthFilterIcon.setSelectedImage(normalImage: UIImage(named: "health") ?? UIImage(),
                                          selectedImage: UIImage(named: "health_selected") ?? UIImage())
        
        natureFilterIcon.setTitle("자연", for: .normal)
        natureFilterIcon.setSelectedImage(normalImage: UIImage(named: "nature") ?? UIImage(),
                                          selectedImage: UIImage(named: "nature_selected") ?? UIImage())
        
    }
    
    @objc func buttonAction(button: FTButton) {
        delegate?.didSelectInfraIcon?(value: button.titleLabel?.text ?? "")
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
