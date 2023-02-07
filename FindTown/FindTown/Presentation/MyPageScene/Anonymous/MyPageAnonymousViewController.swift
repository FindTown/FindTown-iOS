//
//  MyPageAnonymousViewController.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/02.
//

import UIKit

import FindTownCore
import FindTownUI
import RxCocoa
import RxSwift

final class MyPageAnonymousViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let viewModel: MyPageAnonymousViewModel?
    
    // MARK: - Views
    
    private let iconImageView = UIImageView()
    private let titleLabel = FindTownLabel(text: "마이페이지 기능은 회원 가입 후 이용 가능해요.",
                                           font: .body1,
                                           textColor: .grey6,
                                           textAlignment: .center)
    private let subLabel = FindTownLabel(text: "로그인 / 가입 후 더 많은 서비스를 이용해보세요!",
                                         font: .body4,
                                         textColor: .grey5,
                                         textAlignment: .center)
    let signUpButton = FTButton(style: .mediumFilled)
    
    // MARK: - Life Cycle
    
    init(viewModel: MyPageAnonymousViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addView() {
        [iconImageView, titleLabel, subLabel, signUpButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    override func setLayout() {
        NSLayoutConstraint.activate([
            subLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: subLabel.topAnchor, constant: -2.0),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -12.0),
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            signUpButton.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 24.0),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 44.0),
            signUpButton.widthAnchor.constraint(equalToConstant: 152.0)
        ])
    }
    
    override func setupView() {
        self.title = "마이"
        view.backgroundColor = FindTownColor.back2.color
        
        iconImageView.image = UIImage(named: "anonymousIcon")
        titleLabel.setLineHeight(lineHeight: 24.0)
        subLabel.setLineHeight(lineHeight: 20.0)
        signUpButton.setTitle("로그인 / 회원가입하기", for: .normal)
    }
    
    override func bindViewModel() {
        signUpButton.rx.tap
            .bind { [weak self] in
                self?.viewModel?.input.goToLoginTrigger.onNext(())
            }
            .disposed(by: disposeBag)
    }
}
