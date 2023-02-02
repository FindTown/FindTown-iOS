//
//  DemoInfomationCell.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/31.
//

import UIKit

import FindTownUI

final class InfoSectionCollectionViewCell: UICollectionViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    var viewModel: MyPageViewModel?
    
    private var model: MyPageSection.Info?
    
    private let titleLabel: FindTownLabel = FindTownLabel(text: "", font: .body1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(model: MyPageSection.Info) {
        
        self.model = model
        let index = model.index
        
        titleLabel.text = model.title
        
        switch index {
        case 0, 4, 5: // 정보, 로그아웃, 회원탈퇴
            titleLabel.font = FindTownFont.body3.font
            titleLabel.textColor = FindTownColor.grey5.color
        case 3: // 앱버전
            let versionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
            let attributedStr = NSMutableAttributedString(string: titleLabel.text!)
            attributedStr.addAttribute(.font, value: FindTownFont.body4.font,
                                       range: (model.title as NSString).range(of: versionString as? String ?? ""))
            titleLabel.attributedText = attributedStr
        default:
            break
        }
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(cellTap(sender:)))
        contentView.addGestureRecognizer(tapGesture)
    }
    
    @objc func cellTap(sender: UITapGestureRecognizer) {
        
        switch model?.title {
        case "로그아웃":
            viewModel?.delegate.popUpSignout()
        case "회원탈퇴":
            viewModel?.delegate.popUpWithDraw()
        default:
            break
        }
    }
}
