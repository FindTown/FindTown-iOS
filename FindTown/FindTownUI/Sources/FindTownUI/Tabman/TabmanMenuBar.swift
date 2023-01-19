//
//  File.swift
//  
//
//  Created by 김성훈 on 2023/01/18.
//

import UIKit

public protocol TabmanMenuBarDelegate: AnyObject {
    func tabmanMenuBar(scrollTo index: Int)
}

public class TabmanMenuBar: UIView {
    
    // MARK: - Properties
    
    var tabBarTitle: [String]?
    public var indicatorViewLeadingConstraint: NSLayoutConstraint?
    public var indicatorViewWidthConstraint: NSLayoutConstraint?
    
    public weak var delegate: TabmanMenuBarDelegate?
    
    // MARK: - Views
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    public var tabmanMenuBarCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0),
                                              collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    // MARK: - Life Cycle
    
    public init(tabBarTitle: [String]) {
        self.tabBarTitle = tabBarTitle
        
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addView()
        setupView()
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func addView() {
        [tabmanMenuBarCollectionView, indicatorView].forEach {
            self.addSubview($0)
        }
    }
    
    func setLayout() {
        NSLayoutConstraint.activate([
            tabmanMenuBarCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tabmanMenuBarCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tabmanMenuBarCollectionView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        indicatorViewWidthConstraint = indicatorView.widthAnchor.constraint(equalToConstant: self.frame.width / 2)
        indicatorViewWidthConstraint?.isActive = true
        indicatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        indicatorViewLeadingConstraint = indicatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        indicatorViewLeadingConstraint?.isActive = true
        indicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func setupView() {
        tabmanMenuBarCollectionView.delegate = self
        tabmanMenuBarCollectionView.dataSource = self
        tabmanMenuBarCollectionView.register(
            TabmanMenuBarCell.self, forCellWithReuseIdentifier: TabmanMenuBarCell.reuseIdentifier
        )
        let indexPath = IndexPath(item: 0, section: 0)
        tabmanMenuBarCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        
        // indicatorView.isHidden = true
    }
}

extension TabmanMenuBar: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TabmanMenuBarCell.reuseIdentifier, for: indexPath
        ) as? TabmanMenuBarCell {
            cell.title.text = tabBarTitle?[indexPath.row]
            // cell.title.textColor = FindTownColor.grey3.color
            return cell
        }
        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)
    -> Int {
        return tabBarTitle?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Int(self.frame.width) / (tabBarTitle?.count ?? 0) , height: 55)
        // return CGSize(width: 80 , height: 55)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.tabmanMenuBar(scrollTo: indexPath.row)
    }
}

extension TabmanMenuBar: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
