//
//  SignUpFirstInfoViewController.swift
//  FindTown
//
//  Created by 김성훈 on 2022/12/30.
//

import UIKit

import FindTownCore
import FindTownUI
import RxCocoa
import RxSwift

// 웹뷰로 부터 주소 데이터를 받아옴
protocol LocationAndYearsDelegate: AnyObject {
    func dismissKakaoAddressWebView(address: String)
}

final class LocationAndYearsViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let viewModel: LocationAndYearsViewModel?
    private let kakaoAddressUrlString = "https://ungchun.github.io/Kakao-Postcode/"
    
    // MARK: - Views
    
    private let nowStatusPogressView = UIProgressView(progressViewStyle: .bar)
    
    private let whereIsNowTitle = FindTownLabel(text: "지금 어떤 동네에 살고 계신가요?", font: .subtitle4)
    
    private let villageButton = FTButton(style: .largeTinted)
    
    fileprivate let villageStatusLabel = FindTownLabel(text: "주소를 입력해주세요.", font: .label3, textColor: .error)
    
    private let howLongStayTitle = FindTownLabel(text: "얼마나 거주하셨나요?", font: .subtitle4)
    
    private let pickerView: YearMonthPickerView
    
    fileprivate let nextButton = FTButton(style: .largeFilled)
    
    // MARK: - Life Cycle
    
    init(viewModel: LocationAndYearsViewModel) {
        self.viewModel = viewModel
        self.pickerView = YearMonthPickerView(viewModel: self.viewModel!)
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
        [nowStatusPogressView, whereIsNowTitle, villageButton, villageStatusLabel,
         howLongStayTitle, pickerView, nextButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setupView() {
        nowStatusPogressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nowStatusPogressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nowStatusPogressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nowStatusPogressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nowStatusPogressView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            whereIsNowTitle.topAnchor.constraint(equalTo: nowStatusPogressView.bottomAnchor, constant: 48),
            whereIsNowTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
        
        NSLayoutConstraint.activate([
            villageButton.topAnchor.constraint(equalTo: whereIsNowTitle.bottomAnchor, constant: 16),
            villageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            villageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            villageStatusLabel.topAnchor.constraint(equalTo: villageButton.bottomAnchor, constant: 8),
            villageStatusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
        
        NSLayoutConstraint.activate([
            howLongStayTitle.topAnchor.constraint(equalTo: villageButton.bottomAnchor, constant: 68),
            howLongStayTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
        
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pickerView.topAnchor.constraint(equalTo: howLongStayTitle.bottomAnchor, constant: 0),
            pickerView.heightAnchor.constraint(equalToConstant: 200),
            pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    override func setLayout() {
        view.backgroundColor = .white
        
        nowStatusPogressView.trackTintColor = FindTownColor.grey2.color
        nowStatusPogressView.progressTintColor = FindTownColor.primary.color
        nowStatusPogressView.progress = Float(2) / 4.0
        
        villageButton.setTitle("살고 있는 동의 이름을 적어주세요. (ex 신사동)", for: .normal)
        villageButton.contentHorizontalAlignment = .left
        villageButton.configuration?.imagePadding = 10
        villageButton.configuration?.contentInsets.leading = 16
        villageButton.changesSelectionAsPrimaryAction = false
        
        villageStatusLabel.isHidden = true
        
        nextButton.setTitle("다음", for: .normal)
        nextButton.changesSelectionAsPrimaryAction = false
        nextButton.isSelected = false
    }
    
    override func bindViewModel() {
        
        // Input
        
        villageButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                let kakaoAddress = KakaoAddressViewController(webViewTitle: "카카오",
                                                              url: self?.kakaoAddressUrlString)
                kakaoAddress.delegate = self
                self?.present(kakaoAddress, animated: true)
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                self?.viewModel?.input.nextButtonTrigger.onNext(())
            }
            .disposed(by: disposeBag)
        
        // Output
        
        viewModel?.output.nextButtonEnabled
            .asDriver(onErrorJustReturn: (false))
            .drive(self.rx.nextButtonIsSelected)
            .disposed(by: disposeBag)
    }
}

extension LocationAndYearsViewController: LocationAndYearsDelegate {
    func dismissKakaoAddressWebView(address: String) {
        villageButton.configuration?.baseForegroundColor = FindTownColor.grey7.color
        villageButton.setImage(UIImage(named: "MapPinIcon"), for: .normal)
        villageButton.setTitle(address, for: .normal)
        
        viewModel?.input.address.onNext(address)
    }
}

extension Reactive where Base: LocationAndYearsViewController {
    
    var nextButtonIsSelected: Binder<Bool> {
        return Binder(self.base) { view, isEnabled in
            view.nextButton.isSelected = isEnabled
            view.villageStatusLabel.isHidden = isEnabled
        }
    }
}
