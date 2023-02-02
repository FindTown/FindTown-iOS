//
//  Section.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/02.
//

import UIKit

enum MyPageDemoData {
    static let dataSource = [
        MyPageSection.topHeader([ ]),
        MyPageSection.support(
            [
                .init(image: UIImage(),
                      title: "지원"),
                .init(image: UIImage(named: "contact") ?? UIImage(),
                      title: "문의하기"),
                .init(image: UIImage(named: "suggestion") ?? UIImage(),
                      title: "제안하기"),
            ]
        ),
        MyPageSection.info(
            [
                .init(title: "정보",
                      index: 0),
                .init(title: "이용약관",
                      index: 1),
                .init(title: "개인정보처리 방침",
                      index: 2),
                .init(title: "앱버전 v\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)",
                      index: 3),
                .init(title: "로그아웃",
                      index: 4),
                .init(title: "회원탈퇴",
                      index: 5),
            ]
        ),
    ]
}

enum MyPageSection {
    struct TopHeader { }
    
    struct Support {
        let image: UIImage
        let title: String
    }
    
    struct Info {
        let title: String
        let index: Int
    }
    
    case topHeader([TopHeader])
    case support([Support])
    case info([Info])
}
