//
//  AddressSheetViewController.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/08.
//

import UIKit
import FindTownCore

class AddressSheetViewController: BaseBottomSheetViewController {

    var viewModel: AddressSheetViewModel?
    
    let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    init(viewModel: AddressSheetViewModel) {
        super.init(bottomHeight: 488)
        self.viewModel = viewModel
     }
    
    override init(bottomHeight: CGFloat = 488) {
        super.init(bottomHeight: bottomHeight)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

