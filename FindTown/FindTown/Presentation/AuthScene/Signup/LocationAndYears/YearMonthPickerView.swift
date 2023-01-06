//
//  YearMonthPickerView.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/03.
//

import UIKit

import FindTownUI
import RxCocoa
import RxSwift

final class YearMonthPickerView: UIView {
    
    private let disposeBag = DisposeBag()
    
    private var viewModel: LocationAndYearsViewModel?
    
    /// 0 ~ 30년
    private let availableYear = [
        0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
        21, 22, 23, 24, 25, 26, 27, 28, 29, 30
    ]
    /// 1~11월
    private let availableMonth = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
    
    private let pickerView = UIPickerView()
    
    init(viewModel: LocationAndYearsViewModel) {
        super.init(frame: .zero)
        
        self.viewModel = viewModel
        
        addSubview(pickerView)
        
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 100),
            pickerView.centerXAnchor.constraint(equalTo: super.centerXAnchor)
        ])
        
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        
        Observable.just([availableYear, availableMonth])
            .bind(to: pickerView.rx.items(adapter: PickerViewViewAdapter()))
            .disposed(by: disposeBag)
        
        pickerView.rx.modelSelected(Int.self)
            .subscribe(onNext: { [weak self] models in
                self?.viewModel?.input.year.onNext(models[0])
                self?.viewModel?.input.month.onNext(models[1])
            })
            .disposed(by: disposeBag)
    }
}

final class PickerViewViewAdapter: NSObject, UIPickerViewDataSource, UIPickerViewDelegate, RxPickerViewDataSourceType, SectionedViewDataSourceType {
    typealias Element = [[CustomStringConvertible]]
    private var items: [[CustomStringConvertible]] = []
    
    func model(at indexPath: IndexPath) throws -> Any {
        items[indexPath.section][indexPath.row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        items[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(
        _ pickerView: UIPickerView, viewForRow row: Int,
        forComponent component: Int, reusing view: UIView?
    ) -> UIView {
        let pickerLabel = FindTownLabel(text: "", font: .body1, textColor: FindTownColor.grey7)
        pickerLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        pickerLabel.textAlignment = .center
        
        switch component {
        case 0:
            pickerLabel.text = "\(items[component][row])년"
            pickerLabel.widthAnchor.constraint(equalToConstant: pickerView.frame.width / 2 ).isActive = true
            return pickerLabel
        case 1:
            pickerLabel.text = "\(items[component][row])개월"
            pickerLabel.widthAnchor.constraint(equalToConstant: pickerView.frame.width / 2  - 40).isActive = true
            return pickerLabel
        default:
            pickerLabel.text = ""
            return pickerLabel
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, observedEvent: Event<Element>) {
        Binder(self) { (adapter, items) in
            adapter.items = items
            pickerView.reloadAllComponents()
        }.on(observedEvent)
    }
}
