//
//  FavoriteTownViewController.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/09.
//

import UIKit

import FindTownCore
import FindTownUI
import RxCocoa
import RxSwift

final class FavoriteTownViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let viewModel: FavoriteTownViewModel?
    
    // MARK: - Views
    
    private let nowStatusPogressView = UIProgressView(progressViewStyle: .bar)
    
    private let favoriteTitle = FindTownLabel(text: "관심 있는 동네를 찜해보세요", font: .subtitle4)
    
    private let favoriteSubTitle = FindTownLabel(text: "동네 지도에서 인프라를 바로 확인할 수 있어요.",
                                                 font: .body4, textColor: .grey6)
    
    var countyDropDown: DropDown = {
        let dropdown = DropDown(data: ["자치구 (선택)"] + County.allCases.map { $0.rawValue }, contentHeight: 300)
        return dropdown
    }()
    
    lazy var villageDropDown = DropDown(data: ["동 (선택)"], contentHeight: 300)

    private let dropDownsView = UIView()
    
    private let nextButton = FTButton(style: .largeFilled)
    
    // MARK: - Life Cycle
    
    init(viewModel: FavoriteTownViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addView() {
//        dropDownStackView.addArrangedSubview(countyDropDown)
//        dropDownStackView.addArrangedSubview(villageDropDown)
        
        [nowStatusPogressView, favoriteTitle, favoriteSubTitle, dropDownsView, villageDropDown, nextButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [countyDropDown, villageDropDown].forEach {
            dropDownsView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    override func setLayout() {
        
        nowStatusPogressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nowStatusPogressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nowStatusPogressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nowStatusPogressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nowStatusPogressView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            favoriteTitle.topAnchor.constraint(equalTo: nowStatusPogressView.bottomAnchor, constant: 46),
            favoriteTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
        
        NSLayoutConstraint.activate([
            favoriteSubTitle.topAnchor.constraint(equalTo: favoriteTitle.bottomAnchor, constant: 6),
            favoriteSubTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
        
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            dropDownsView.topAnchor.constraint(equalTo: favoriteSubTitle.bottomAnchor, constant: 16),
            dropDownsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dropDownsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dropDownsView.heightAnchor.constraint(equalToConstant: 300),
        ])
        
        NSLayoutConstraint.activate([
            countyDropDown.topAnchor.constraint(equalTo: favoriteSubTitle.bottomAnchor, constant: 16),
            countyDropDown.leadingAnchor.constraint(equalTo: dropDownsView.leadingAnchor),
            countyDropDown.widthAnchor.constraint(equalToConstant: 164),
            
            villageDropDown.topAnchor.constraint(equalTo: countyDropDown.topAnchor),
            villageDropDown.leadingAnchor.constraint(equalTo: countyDropDown.trailingAnchor, constant: 14),
            villageDropDown.widthAnchor.constraint(equalToConstant: 164),
        ])
    }
    
    override func setupView() {
        view.backgroundColor = .white
        
        nowStatusPogressView.trackTintColor = FindTownColor.grey2.color
        nowStatusPogressView.progressTintColor = FindTownColor.primary.color
        nowStatusPogressView.progress = Float(4) / 4.0
        
        nextButton.setTitle("다음", for: .normal)
        nextButton.changesSelectionAsPrimaryAction = false
        nextButton.isSelected = false
        nextButton.isEnabled = false
        
        let skipButton = UIBarButtonItem(title: "건너뛰기", style: .plain, target: self,
                                         action: #selector(didTapSkipButton))
        skipButton.tintColor = FindTownColor.grey5.color
        let attributes: [NSAttributedString.Key: Any] = [.font: FindTownFont.label1.font]
        navigationController?.navigationBar.titleTextAttributes = attributes
        skipButton.setTitleTextAttributes(attributes, for: .normal)
        navigationItem.rightBarButtonItem = skipButton
        
        setupTapGesture()
    }

    override func bindViewModel() {
        
        // Input
        
        nextButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                self?.viewModel?.input.nextButtonTrigger.onNext(())
            }
            .disposed(by: disposeBag)
        
        countyDropDown.rx.didSelectDropDown
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                let splitValue = $0?.split(separator: " ").first
                guard let splitValue = splitValue,
                let county = County(rawValue: String(splitValue)) else { return }
                self?.viewModel?.input.county.onNext(county)
                self?.villageDropDown.reloadData(data: ["동 (선택)"] + county.villages.map { $0.rawValue })
            }
            .disposed(by:disposeBag)
        
        villageDropDown.rx.didSelectDropDown
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                let splitValue = $0?.split(separator: " ").first
                guard let splitValue = splitValue else { return }
                self?.viewModel?.input.village.onNext(Village(rawValue: String(splitValue)))
            }
            .disposed(by: disposeBag)
        
        // Output
        
        viewModel?.output.buttonsSelected
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive { [weak self] in
                self?.nextButton.isSelected = $0
                self?.nextButton.isEnabled = $0
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Functions
    
    private func setupTapGesture() {
        let backViewTap = UITapGestureRecognizer(target: self, action: #selector(backViewTapped(_:)))
        backViewTap.cancelsTouchesInView = false
        view.addGestureRecognizer(backViewTap)
    }
    
    @objc private func backViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        let backViewTappedLocation = tapRecognizer.location(in: self.dropDownsView)
        if dropDownsView.point(inside: backViewTappedLocation, with: nil) == false {
            countyDropDown.dismiss()
            villageDropDown.dismiss()
        }
    }
    
    @objc private func didTapSkipButton() {
        viewModel?.input.cityCode.onNext(nil)
        viewModel?.input.nextButtonTrigger.onNext(())
    }
}
