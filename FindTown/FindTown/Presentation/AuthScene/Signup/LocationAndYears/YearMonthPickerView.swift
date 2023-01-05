//
//  YearMonthPickerView.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/03.
//

import UIKit
import FindTownUI

final class YearMonthPickerView: UIView {
    
    /// 0 ~ 30년
    private let availableYear = [
        0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
        21, 22, 23, 24, 25, 26, 27, 28, 29, 30
    ]
    /// 1~11월
    private let availableMonth = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
    
    private let pickerView = UIPickerView()
    
    private var viewModel: LocationAndYearsViewModel!
    
    init(viewModel: LocationAndYearsViewModel) {
        super.init(frame: .zero)
        self.viewModel = viewModel
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(0, inComponent: 0, animated: true)
        pickerView.selectRow(0, inComponent: 1, animated: true)
        
        addSubview(pickerView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension YearMonthPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2 /// 년, 월 두 가지 선택하는 피커뷰
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return availableYear.count /// 연도의 아이템 개수
        case 1:
            return availableMonth.count /// 월의 아이템 개수
        default:
            return 0
        }
    }
    
    func pickerView(
        _ pickerView: UIPickerView, viewForRow row: Int,
        forComponent component: Int, reusing view: UIView?
    ) -> UIView {
        let pickerLabel = FindTownLabel(text: "", font: .body1, textColor: FindTownColor.grey7)
        pickerLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        switch component {
        case 0:
            viewModel.input.year.onNext(availableYear[row])
            pickerLabel.text = "\(availableYear[row])년"
            return pickerLabel
        case 1:
            viewModel.input.month.onNext(availableMonth[row])
            pickerLabel.text = "\(availableMonth[row])개월"
            return pickerLabel
        default:
            pickerLabel.text = ""
            return pickerLabel
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 0 {
            return 100
        } else {
            return 50
        }
    }
}
