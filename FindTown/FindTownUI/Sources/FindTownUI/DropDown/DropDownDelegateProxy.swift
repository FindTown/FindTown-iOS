//
//  File.swift
//  
//
//  Created by 김성훈 on 2023/01/09.
//

import UIKit
import RxSwift
import RxCocoa

public class DropDownDelegateProxy: DelegateProxy<DropDown, DropDownDelegate>, DelegateProxyType, DropDownDelegate{

    public static func registerKnownImplementations() {
        self.register { (textField) -> DropDownDelegateProxy in
            DropDownDelegateProxy(parentObject: textField, delegateProxy: self)
        }
    }

    public static func currentDelegate(for object: DropDown) -> DropDownDelegate? {
        return object.delegate
    }

    public static func setCurrentDelegate(_ delegate: DropDownDelegate?, to object: DropDown) {
        object.delegate = delegate
    }
}

extension Reactive where Base: DropDown {

    var delegate : DelegateProxy<DropDown, DropDownDelegate> {
        return DropDownDelegateProxy.proxy(for: self.base)
    }

    public var didSelectDropDown: Observable<String?> {
        return delegate.methodInvoked(#selector(DropDownDelegate.didSelectDropDown(value:)))
            .map { dropDownData in
                let index = dropDownData.first as! String
                return index
            }
    }
}
