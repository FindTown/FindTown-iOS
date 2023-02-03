//
//  MyTownReviewViewModel.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/01.
//

import Foundation

import FindTownCore
import RxSwift
import RxRelay

protocol MyTownReviewViewModelType { }

// 임시
struct reviewModelTest {
    let village: String
    let period: String
    let introduce: String
}

final class MyTownReviewViewModel: BaseViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        var reviewTableDataSource = BehaviorRelay<[reviewModelTest]>(value: [])
    }
    
    let input = Input()
    let output = Output()
    let delegate: MyPageViewModelDelegate
    
    init(
        delegate: MyPageViewModelDelegate
    ) {
        self.delegate = delegate
        
        super.init()
        self.bind()
    }
    
    func bind() {
        self.output.reviewTableDataSource.accept(returnReviewTestData())
    }
}

extension MyTownReviewViewModel {
    func returnReviewTestData() -> [reviewModelTest] {
        let demoReview1 = reviewModelTest(village: "서울시 관악구 신림동",
                                          period: "2년 6개월 거주",
                                          introduce: "집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 ")
        let demoReview2 = reviewModelTest(village: "서울시 관악구 신림동",
                                          period: "2년 6개월 거주",
                                          introduce: "집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 ")
        let demoReview3 = reviewModelTest(village: "서울시 관악구 신림동",
                                          period: "2년 6개월 거주",
                                          introduce: "집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 ")
        let demoReview4 = reviewModelTest(village: "서울시 관악구 신림동",
                                          period: "2년 6개월 거주",
                                          introduce: "집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 집 앞에 산책 ")
        
        let reviews = [demoReview1, demoReview2, demoReview3, demoReview4]
        return reviews
    }
}
