//
//  LoginViewController.swift
//  FindTown
//
//  Created by 김성훈 on 2022/12/29.
//

import UIKit

import FindTownCore
import FindTownUI
import KakaoSDKUser
import RxCocoa
import RxSwift
import AuthenticationServices

final class LoginViewController: BaseViewController {
    
    // MARK: - Properties
    
    let viewModel: LoginViewModel?
    
    private let anonymousTitleTapGesture = UITapGestureRecognizer()
    
    // MARK: - Views

    private let subTitle = FindTownLabel(text: "동네의 모든 정보를 한번에", font: .body1)
    private let logo = UIImageView(image: UIImage(named: "logo"))
    private let tooltip = ToolTip(text: "👋🏻  가입 후 서비스를 자유롭게 이용해보세요!",
                                  viewColor: .white,
                                  textColor: .grey7,
                                  tipLocation: .bottom,
                                  width: 236,
                                  height: 32)
    
    private let kakaoButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "카카오로 시작하기"
        configuration.image = UIImage(named: "KakaoIcon")
        configuration.baseBackgroundColor = #colorLiteral(red: 0.9983025193, green: 0.9065476656, blue: 0, alpha: 1)
        configuration.baseForegroundColor = FindTownColor.black.color
        configuration.imagePadding = 9
        configuration.attributedTitle?.font = FindTownFont.body1.font
        
        let button = UIButton(configuration: configuration)
        return button
    }()
    
    private let appleButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Apple로 시작하기"
        configuration.image = UIImage(named: "AppleIcon")
        configuration.baseBackgroundColor = FindTownColor.black.color
        configuration.baseForegroundColor = FindTownColor.white.color
        configuration.imagePadding = 9
        configuration.attributedTitle?.font = FindTownFont.body1.font
        
        let button = UIButton(configuration: configuration)
        return button
    }()
    
    private let lookAroundButton: UIButton = {
        var button = UIButton()
        button.setTitle("둘러보기", for: .normal)
        button.setTitleColor(FindTownColor.grey5.color, for: .normal)
        button.titleLabel?.font = FindTownFont.body3.font
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .clear
        return button
    }()
    
    // MARK: - Life Cycle
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Functions
    
    override func addView() {
        [logo, subTitle, tooltip, kakaoButton, appleButton, lookAroundButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    override func setLayout() {
        let screenBounds = UIScreen.main.bounds
        
        NSLayoutConstraint.activate([
            subTitle.bottomAnchor.constraint(equalTo: logo.topAnchor, constant: -4),
            subTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            logo.widthAnchor.constraint(equalToConstant: 152),
            logo.heightAnchor.constraint(equalToConstant: 34),
            logo.topAnchor.constraint(equalTo: view.topAnchor,
                                      constant: screenBounds.height / 2.4),
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tooltip.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tooltip.bottomAnchor.constraint(equalTo: kakaoButton.topAnchor, constant: -30)
        ])
        
        NSLayoutConstraint.activate([
            kakaoButton.topAnchor.constraint(equalTo: subTitle.bottomAnchor,
                                             constant: screenBounds.height / 3.4),
            kakaoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            kakaoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            kakaoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            kakaoButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([
            appleButton.topAnchor.constraint(equalTo: kakaoButton.bottomAnchor, constant: 12),
            appleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            appleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            appleButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([
            lookAroundButton.topAnchor.constraint(equalTo: appleButton.bottomAnchor, constant: 38),
            lookAroundButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lookAroundButton.widthAnchor.constraint(equalToConstant: 70),
            lookAroundButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    override func setupView() {
        view.backgroundColor = .white
    }
    
    override func bindViewModel() {
        
        // Input
        
        /// kakao 로그인
        kakaoButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                self?.viewModel?.input.kakaoSigninTrigger.onNext(())
            }
            .disposed(by: disposeBag)
        
        /// apple 로그인
        appleButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                self?.viewModel?.input.appleSigninTrigger.onNext(())
            }
            .disposed(by: disposeBag)
        
        /// 둘러보기
        lookAroundButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                self?.viewModel?.input.anonymousTrigger.onNext(())
            }
            .disposed(by: disposeBag)
        
        // Output
        
        self.viewModel?.output.errorNotice
            .subscribe { [weak self] _ in
                self?.showErrorNoticeAlertPopUp(message: "네트워크 오류가 발생하였습니다.", buttonText: "확인")
            }
            .disposed(by: disposeBag)
        
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        self.view.window!
    }
}
