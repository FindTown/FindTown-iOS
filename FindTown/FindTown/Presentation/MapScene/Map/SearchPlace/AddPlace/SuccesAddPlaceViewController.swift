//
//  SuccesAddPlaceViewController.swift
//  FindTown
//
//  Created by 장선영 on 2023/11/01.
//

import UIKit

import FindTownCore
import FindTownUI

import RxCocoa
import SnapKit

final class SuccesAddPlaceViewController: BaseViewController {
    
    private let closeButton = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: nil, action: nil)
    
    private let checkImageView = UIImageView()
    private let titleLabel = FindTownLabel(text: "장소 등록 요청이 완료되었습니다.",
                                           font: .body1,
                                           textAlignment: .center)
    private let subtitleLabel = FindTownLabel(text: "소중한 제보 감사드립니다.",
                                              font: .body4,
                                              textColor: .grey6,
                                              textAlignment: .center)
    private let infoView = UIView()
    private let questionImageView = UIImageView()
    private let questionTitleLabel = FindTownLabel(text: "요청이 완료되면 바로 테마 지도에 등록이 되나요?",
                                                   font: .body3,
                                                   textColor: .primary)
    private let infoSubtitleLabel = FindTownLabel(text: "동일한 장소를 5회 이상 등록 요청 시, 테마 지도에 최종적으로 등록됩니다.",
                                                  font: .body4,
                                                  textColor: .grey6)
    private let okButton = FTButton(style: .mediumFilled)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = closeButton
    }
    
    override func bindViewModel() {
        closeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        okButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                
            })
            .disposed(by: disposeBag)
    }
    
    override func setupView() {
        checkImageView.image = UIImage(named: "icon_complete")
        questionImageView.image = UIImage(named: "octicon_question-24")
        infoView.backgroundColor = FindTownColor.back1.color
        infoView.layer.cornerRadius = 8
        infoView.layer.borderColor = FindTownColor.grey3.color.cgColor
        infoView.layer.borderWidth = 1
        infoSubtitleLabel.numberOfLines = 2
        infoSubtitleLabel.setLineHeight(lineHeight: 20)
        okButton.setTitle("확인", for: .normal)
    }
    
    override func addView() {
        [checkImageView, titleLabel, subtitleLabel, infoView, okButton].forEach {
            self.view.addSubview($0)
        }
        
        [questionImageView, questionTitleLabel, infoSubtitleLabel].forEach {
            infoView.addSubview($0)
        }
    }
    
    override func setLayout() {
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        checkImageView.snp.makeConstraints {
            $0.top.equalTo(safeArea).inset(132)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(64)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(checkImageView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
        }
        
        infoView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(48)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(96)
        }
        
        questionImageView.snp.makeConstraints {
            $0.width.height.equalTo(16)
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(26)
        }
        
        questionTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(questionImageView)
            $0.leading.equalTo(questionImageView.snp.trailing).offset(6)
            $0.trailing.equalToSuperview().inset(25)
        }
        
        infoSubtitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(questionTitleLabel)
            $0.top.equalTo(questionTitleLabel.snp.bottom).offset(4)
        }
        
        okButton.snp.makeConstraints {
            $0.bottom.equalTo(safeArea)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
    }
}
