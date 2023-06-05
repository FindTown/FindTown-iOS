//
//  TownMoodSelectViewController.swift
//  FindTown
//
//  Created by 이호영 on 2023/06/05.
//

import UIKit

import FindTownCore
import FindTownUI

import RxCocoa
import RxSwift
import AlignedCollectionViewFlowLayout

final class TownMoodSelectViewController: BaseViewController {
    
    // MARK: - Properteis
    
    private let viewModel: TownMoodSelectViewModel?
    
    // MARK: - Views
    
    private let nowStatusPogressView = UIProgressView(progressViewStyle: .bar)
  
    public let noticeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 6
        return stackView
    }()
    
    private let moodAskLabel = FindTownLabel(text: "동네 분위기는 어떤가요?", font: .subtitle4)
    
    private let noticeLabel = FindTownLabel(text: "최대 7개까지 선택할 수 있어요.", font: .body4, textColor: .grey6)
  
    private let moodScrollView = UIScrollView()
    public let moodContentView = UIView()
    public let moodStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 42
        return stackView
    }()
      
    private var moodCollectionView: UICollectionView = {
      let collectionViewLayout = AlignedCollectionViewFlowLayout()
      collectionViewLayout.horizontalAlignment = .left
      collectionViewLayout.verticalAlignment = .top
      collectionViewLayout.scrollDirection = .vertical
      collectionViewLayout.minimumInteritemSpacing = 8
      collectionViewLayout.estimatedItemSize = CGSize(width: 53, height: 32)
      collectionViewLayout.sectionInset = UIEdgeInsets(top: 12, left: 0, bottom: 24, right: 0)
      let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0),
                                            collectionViewLayout: collectionViewLayout)
      collectionView.translatesAutoresizingMaskIntoConstraints = false
      collectionView.isScrollEnabled = false
      return collectionView
    }()
    
    private let nextButton = FTButton(style: .largeFilled)
  
    private var selectItems: [TownMood] = []
    
    // MARK: - Life Cycle
    
    init(viewModel: TownMoodSelectViewModel) {
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
        
      view.addSubview(moodScrollView)
      moodScrollView.addSubview(moodContentView)
      moodContentView.addSubview(moodStackView)
      
      [nowStatusPogressView, nextButton].forEach {
            view.addSubview($0)
        }
      
      [noticeStackView,
       moodCollectionView].forEach {
        moodStackView.addArrangedSubview($0)
      }
      
      [moodAskLabel,
       noticeLabel].forEach {
        noticeStackView.addArrangedSubview($0)
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
      
      moodScrollView.translatesAutoresizingMaskIntoConstraints = false
      moodContentView.translatesAutoresizingMaskIntoConstraints = false
      moodStackView.translatesAutoresizingMaskIntoConstraints = false
      
      NSLayoutConstraint.activate([
        moodScrollView.topAnchor.constraint(equalTo: nowStatusPogressView.topAnchor),
        moodScrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
        moodScrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
        moodScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -72),
          
        moodContentView.topAnchor.constraint(equalTo: self.moodScrollView.topAnchor, constant: 46),
        moodContentView.leadingAnchor.constraint(equalTo: self.moodScrollView.leadingAnchor),
        moodContentView.trailingAnchor.constraint(equalTo: self.moodScrollView.trailingAnchor),
        moodContentView.bottomAnchor.constraint(equalTo: self.moodScrollView.bottomAnchor),
        moodContentView.widthAnchor.constraint(equalTo: self.moodScrollView.widthAnchor),
          
        moodStackView.topAnchor.constraint(equalTo: moodContentView.topAnchor),
        moodStackView.leadingAnchor.constraint(equalTo: moodContentView.leadingAnchor, constant: 16),
        moodStackView.trailingAnchor.constraint(equalTo: moodContentView.trailingAnchor, constant: -16),
        moodStackView.bottomAnchor.constraint(equalTo: moodContentView.bottomAnchor)
      ])
        
        NSLayoutConstraint.activate([
            moodCollectionView.heightAnchor.constraint(equalToConstant: 700)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            nextButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nextButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    override func setupView() {
        
        view.backgroundColor = .white
      
        moodCollectionView.delegate = self
        moodCollectionView.dataSource = self
      
        moodScrollView.backgroundColor = .white
      
        moodCollectionView.allowsMultipleSelection = true
        moodCollectionView.register(
          TownMoodSelectCollectionViewCell.self,
          forCellWithReuseIdentifier: TownMoodSelectCollectionViewCell.reuseIdentifier
        )
        moodCollectionView.register(TownMoodSelectHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TownMoodSelectHeaderView.reuseIdentifier)
        
        nowStatusPogressView.trackTintColor = FindTownColor.grey2.color
        nowStatusPogressView.progressTintColor = FindTownColor.primary.color
        nowStatusPogressView.progress = Float(4) / 5.0
        
        nextButton.setTitle("다음", for: .normal)
        nextButton.changesSelectionAsPrimaryAction = false
        nextButton.isSelected = false
        nextButton.isEnabled = false
    }
    
    override func bindViewModel() {
        
        // Input
        
        nextButton.rx.tap
            .bind { [weak self] in
                self?.view.endEditing(true)
                self?.viewModel?.input.nextButtonTrigger.onNext(())
            }
            .disposed(by: disposeBag)
        
        // Output
        
        viewModel?.output.buttonsSelected
            .asDriver(onErrorJustReturn: false)
            .drive { [weak self] isSelected in
                self?.buttonIsSelectedChange(isSelected)
            }
            .disposed(by: disposeBag)
    }
    
    private func buttonIsSelectedChange(_ isSelected: Bool) {
        if isSelected != nextButton.isSelected {
            nextButton.isSelected = isSelected
            nextButton.isEnabled = isSelected
        }
    }
}

extension TownMoodSelectViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return TownMoodCategory.allCases.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return TownMoodCategory.allCases[section].items.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TownMoodSelectCollectionViewCell.reuseIdentifier, for: indexPath) as? TownMoodSelectCollectionViewCell else {
      return UICollectionViewCell()
    }
    cell.setupCell(TownMoodCategory.allCases[indexPath.section].items[indexPath.row].emojiDescription)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    if let selectItems = collectionView.indexPathsForSelectedItems,
       selectItems.count <= 7 {
      return true
    } else {
      return false
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    selectItems.append(TownMoodCategory.allCases[indexPath.section].items[indexPath.row])
    self.viewModel?.input.selectedMoodItems.onNext(selectItems)
  }
  
  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    selectItems = selectItems.filter {
      TownMoodCategory.allCases[indexPath.section].items[indexPath.row] != $0
    }
    self.viewModel?.input.selectedMoodItems.onNext(selectItems)
  }
}

extension TownMoodSelectViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
          return CGSize(width: collectionView.bounds.width, height: 24)
    
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TownMoodSelectHeaderView.reuseIdentifier, for: indexPath) as? TownMoodSelectHeaderView else {
                    return UICollectionReusableView()
                }
    header.setupCell(TownMoodCategory.allCases[indexPath.section].description)
    return header
  }
}
