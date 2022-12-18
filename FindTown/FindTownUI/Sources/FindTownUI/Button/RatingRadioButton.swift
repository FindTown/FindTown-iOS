//
//  File.swift
//  
//
//  Created by 김성훈 on 2022/12/15.
//

import UIKit

public final class RatingRadioButton: UIView {
    
    public enum StarType {
        case none
        case three
        case five
    }
    
    private var starType: StarType
    private var labelPadding: Double = 10.0
    
    private let backgroundView: UIView = {
        let view = UIView()
        return view
    }()
    
    public let radioButton: RadioButton = {
        let btn = RadioButton()
        btn.isUserInteractionEnabled = false
        return btn
    }()
    
    private lazy var starStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.isUserInteractionEnabled = false
        return stackView
    }()
    
    private let star1: StarButton = {
        let btn = StarButton()
        btn.isUserInteractionEnabled = false
        return btn
    }()
    
    private let star2: StarButton = {
        let btn = StarButton()
        btn.isUserInteractionEnabled = false
        return btn
    }()
    
    private let star3: StarButton = {
        let btn = StarButton()
        btn.isUserInteractionEnabled = false
        return btn
    }()
    
    private let star4: StarButton = {
        let btn = StarButton()
        btn.isUserInteractionEnabled = false
        return btn
    }()
    
    private let star5: StarButton = {
        let btn = StarButton()
        btn.isUserInteractionEnabled = false
        return btn
    }()
    
    private let ratingGuirdTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        return label
    }()
    
    public init(starType: StarType) {
        self.starType = starType
        super.init(frame: CGRect.zero)
        
        addView()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addView() {
        let starButtons = [star1, star2, star3, star4, star5]
        
        starButtons.forEach {
            starStackView.addArrangedSubview($0)
        }
        
        backgroundView.addSubview(radioButton)
        backgroundView.addSubview(starStackView)
        backgroundView.addSubview(ratingGuirdTitle)
        
        switch starType {
        case .none:
            [star1, star2, star3, star4, star5].forEach {
                $0.isHidden = true
            }
            labelPadding = 0
            ratingGuirdTitle.text = "크게 중요하지 않아요."
        case .three:
            [star1, star2, star3].forEach {
                $0.isSelected = true
            }
            ratingGuirdTitle.text = "중요해요."
        case .five:
            [star1, star2, star3, star4, star5].forEach {
                $0.isSelected = true
            }
            ratingGuirdTitle.text = "매우 중요해요."
        }
        
        addSubview(backgroundView)
    }
    
    private func setLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        
        radioButton.leftAnchor.constraint(equalTo: super.leftAnchor).isActive = true
        radioButton.centerYAnchor.constraint(equalTo: super.centerYAnchor).isActive = true
        
        starStackView.leftAnchor.constraint(equalTo: radioButton.rightAnchor, constant: 10).isActive = true
        starStackView.centerYAnchor.constraint(equalTo: super.centerYAnchor).isActive = true
        
        ratingGuirdTitle.leftAnchor.constraint(equalTo: starStackView.rightAnchor, constant: labelPadding).isActive = true
        ratingGuirdTitle.centerYAnchor.constraint(equalTo: super.centerYAnchor).isActive = true
    }
}
