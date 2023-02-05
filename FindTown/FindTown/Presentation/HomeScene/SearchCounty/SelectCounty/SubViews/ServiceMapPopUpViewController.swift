//
//  SearchFirstEnterPopUpViewController.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/05.
//

import UIKit

import FindTownUI
import FindTownCore
import RxCocoa
import RxSwift

final class ServiceMapPopUpViewController: ContentPopUpViewController {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Views
    
    private let mainTitleLabel = FindTownLabel(text: "현재 서비스 제공 지역 안내", font: .headLine3)
    private let subTitleLabel = FindTownLabel(text: "서울특별시 자치구 25개 중 현재 14개의\n구별 27개 동 안내 서비스를 제공 중입니다.", font: .label1, textColor: .grey6, textAlignment: .center)
    
    private let serviceMapImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "serviceMap")
        return imageView
    }()
    
    private let confirmButton = FTButton(style: .largeFilled)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.addSubview(mainTitleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(serviceMapImageView)
        contentView.addSubview(confirmButton)
        
        NSLayoutConstraint.activate([
            mainTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 36),
            mainTitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 6),
            subTitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            serviceMapImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14.0),
            serviceMapImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 100.0),
            serviceMapImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            serviceMapImageView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -20.0),
        ])
        
        NSLayoutConstraint.activate([
            confirmButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            confirmButton.topAnchor.constraint(equalTo: serviceMapImageView.bottomAnchor, constant: 20.0),
            confirmButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20.0),
            confirmButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
        
        topLeftButton.isHidden = true
        
        subTitleLabel.numberOfLines = 0
        subTitleLabel.setLineHeight(lineHeight: 20)
        
        confirmButton.isSelected = true
        confirmButton.setTitle("확인했어요", for: .normal)
        
        confirmButton.rx.tap
            .bind { [weak self] in
                UserDefaults.standard.set(true, forKey: "SearchFirstEnter")
                self?.dismiss(animated: false)
            }
            .disposed(by: disposeBag)
    }
}
