//
//  AddPlaceViewController.swift
//  FindTown
//
//  Created by 장선영 on 2023/10/31.
//

import UIKit

import FindTownCore
import FindTownUI

import SnapKit
import RxSwift
import RxCocoa

enum PlaceStatus {
    case isRegistered
    case notRegistered
}

final class AddPlaceViewController: BaseViewController {
    
    private let closeButton = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: nil, action: nil)
    private let doneButton = UIBarButtonItem(title: "완료", style: .done, target: nil, action: nil)
    
    let placeInfoView = PlaceInfoView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func bindViewModel() {
        doneButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                let nextVC = SuccesAddPlaceViewController()
                self?.navigationController?.pushViewController(nextVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    override func setupView() {
        self.view.backgroundColor = .white
        self.title = "장소 등록"
        self.navigationItem.leftBarButtonItem = closeButton
        self.navigationItem.rightBarButtonItem = doneButton
//        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        self.stackView.layoutMargins = UIEdgeInsets(top: 24,
                                                    left: 16,
                                                    bottom: 0,
                                                    right: 16)
        
        self.stackView.isLayoutMarginsRelativeArrangement = true
    }
    
    override func addView() {
        super.addView()
        
        [placeInfoView].forEach {
            self.stackView.addArrangedSubview($0)
        }
    }
    
    override func setLayout() {
        super.setLayout()
        
        let safeArea = self.view.safeAreaLayoutGuide
//        contentView.add
        
    }
}
