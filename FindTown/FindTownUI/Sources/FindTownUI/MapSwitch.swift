//
//  File.swift
//  
//
//  Created by 장선영 on 2022/12/20.
//

import Foundation
import UIKit

/// 동네지도 에서 사용되는 인프라, 테마 지도 전환 Switch
public class MapSwitch: UISegmentedControl {
    
    /// init할 때 segment들의 title을 string 배열로 받음
    public init(items: [String]) {
        super.init(items: items)
        translatesAutoresizingMaskIntoConstraints = false
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.bounds.size.height / 2.0
        layer.masksToBounds = true
        
        /// 선택된 segment의 상단 흰색 뷰 둥글게
        let foregroundIndex = numberOfSegments
        if subviews.indices.contains(foregroundIndex),
           let foregroundImageView = subviews[foregroundIndex] as? UIImageView {

            foregroundImageView.image = UIImage()
            foregroundImageView.backgroundColor = FindTownColor.white.color
            foregroundImageView.bounds = foregroundImageView.bounds.insetBy(dx: 8.0,
                                                                            dy: 6.0)
            foregroundImageView.layer.removeAnimation(forKey: "SelectionBounds")
            foregroundImageView.layer.cornerRadius = foregroundImageView.bounds.height / 2.0
        }
    }
}

private extension MapSwitch {
    
    func configureUI() {
        /// width, height 크기 설정
        self.heightAnchor.constraint(equalToConstant: 39.0).isActive = true
        self.widthAnchor.constraint(equalToConstant: 126.0).isActive = true
        
        /// font 설정
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: FindTownColor.black.color,
                                     NSAttributedString.Key.font: FindTownFont.body3.font],
                                    for: .selected)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: FindTownColor.grey5.color,
                                     NSAttributedString.Key.font: FindTownFont.body3.font],
                                    for: .normal)
        
        self.backgroundColor = .clear
        self.clipsToBounds = true
        removeDivider()
    }
    
    /// segment 사이 구분선 제거 메서드
    func removeDivider() {
        let emptyImage = UIImage()
        self.setDividerImage(emptyImage,
                             forLeftSegmentState: .selected,
                             rightSegmentState: .normal,
                             barMetrics: .default)
    }
}
