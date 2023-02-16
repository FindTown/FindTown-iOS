//
//  File.swift
//
//
//  Created by 장선영 on 2022/12/29.
//

import Foundation
import UIKit

@objc public protocol DropDownDelegate: AnyObject {
    @objc optional func didSelectDropDown(value: String)
}

public enum DropDownStatus {
    case selected    /// dataSource 중 0번째 이외의 값이 선택된 경우
    case nonSelected /// dataSource 중 0번째(안내 데이터)가 선택된 경우
}

/// 커스텀 드롭다운, 드롭다운의 세로 길이가 데이터 목록을 보여주는 tableView의 세로 길이가 됨
public class DropDown: UIView {
    
    public weak var delegate: DropDownDelegate?
    
    /// 0번째에는 데이터가 아닌 안내 텍스트 (ex:자치구(선택)) 가 들어감
    private var dataSource: [String]
    
    public var status: DropDownStatus = .nonSelected {
        didSet {
            switch status {
            case .selected:
                textView.layer.borderColor = FindTownColor.grey7.color.cgColor
                textLabel.textColor = FindTownColor.grey7.color
                dropDownImageView.image = UIImage(named: "dropButtonBlack", in: .module, compatibleWith: nil)
            case .nonSelected:
                textView.layer.borderColor = FindTownColor.grey5.color.cgColor
                textLabel.textColor = FindTownColor.grey5.color
                dropDownImageView.image = UIImage(named: "dropButtonGrey", in: .module, compatibleWith: nil)
            }
        }
    }
    
    var textView: UIView = {
        let view = UIView()
        view.layer.borderColor = FindTownColor.grey5.color.cgColor
        view.backgroundColor = FindTownColor.white.color
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.isUserInteractionEnabled = true
        return view
    }()
    
    var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = FindTownColor.grey5.color
        label.font = FindTownFont.label1.font
        return label
    }()
    
    var dropDownImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "dropButtonGrey", in: .module, compatibleWith: nil)
        return imageView
    }()
    
    /// 그림자를 표현하기 위한 껍데기 뷰
    var shadowView: UIView = {
        let view = UIView()
        view.layer.addCustomShadow(shadowX: 0,
                                   shadowY: 4,
                                   shadowColor: UIColor(red: 194/255,
                                                        green: 191/255,
                                                        blue: 198/255,
                                                        alpha: 0.6),
                                   blur: 20.0,
                                   spread: 0.0,
                                   alpha: 0.6)
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.alpha = 0
        return view
    }()
    
    lazy var tableView: DropDownTableView = {
        let tableView = DropDownTableView()
        tableView.backgroundColor = FindTownColor.white.color
        tableView.layer.cornerRadius = 8
        tableView.register(DropDownCell.self,
                           forCellReuseIdentifier: DropDownCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    var contentHeight: Int?
    
    /// data : 드롭다운에서 보여줄 텍스트 배열, 0번째에는 안내텍스트 ex: 자치구(선택) 이 들어감
    public init(data: [String], contentHeight: Int? = nil) {
        self.dataSource = data
        self.contentHeight = contentHeight
        super.init(frame: .zero)
        
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        
        setLayout()
        addTapGestureToTextView()
        setTableViewFirstCellSelected()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func dismiss() {
        self.shadowView.alpha = 0
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension DropDown: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DropDownCell.reuseIdentifier,
                                                       for: indexPath) as? DropDownCell else {
            return UITableViewCell()
        }
        
        cell.setUpCell(text: dataSource[indexPath.row])
        cell.separatorInset = UIEdgeInsets.zero
        cell.selectionStyle = .none
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.status = .nonSelected
        } else {
            self.status = .selected
        }
        
        textLabel.text = dataSource[indexPath.row]
        
        delegate?.didSelectDropDown?(value: dataSource[indexPath.row])
        
        shadowView.alpha = 0
    }
    
    public func reloadData(data: [String]) {
        DispatchQueue.main.async {
            self.dataSource = data
            self.tableView.reloadData()
            self.tableView.performBatchUpdates { [weak self] in
                guard let constraints = self?.tableView.constraints else { return }
                guard var intrinsicContenttHeight = self?.tableView.intrinsicContentSize.height,
                      let view = self?.shadowView,
                      let contentHeight = self?.contentHeight else { return }
                
                if intrinsicContenttHeight > CGFloat(contentHeight) {
                    intrinsicContenttHeight = CGFloat(contentHeight)
                }
                self?.tableView.removeConstraints(constraints)
                
                self?.tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
                self?.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
                self?.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
                self?.tableView.heightAnchor.constraint(equalToConstant: CGFloat(intrinsicContenttHeight)).isActive = true

                self?.layoutIfNeeded()
            }
        }
    }
}


// MARK: 기타 메서드

private extension DropDown {
    
    /// textView 텝 하면 shadowView(tableView) 나타나게 함
    func addTapGestureToTextView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showTableView))
        textView.addGestureRecognizer(gesture)
    }
    
    @objc func showTableView() {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: [.allowUserInteraction, .curveEaseOut],
                       animations: {
            self.shadowView.alpha = 1
            self.layoutIfNeeded()},
                       completion: nil)
    }
    
    /// 0번째 cell이 선택된 상태로 시작하게 함
    func setTableViewFirstCellSelected() {
        textLabel.text = dataSource[0]
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    }
}


// MARK: Layout 설정

private extension DropDown {
    
    func setLayout() {
        if let contentHeight = contentHeight {
            let intrinsicContenttHeight = self.tableView.intrinsicContentSize.height
            if intrinsicContenttHeight < CGFloat(contentHeight) {
                tableView.heightAnchor.constraint(equalToConstant: intrinsicContenttHeight).isActive = true
            } else {
                tableView.heightAnchor.constraint(equalToConstant: CGFloat(contentHeight)).isActive = true
            }
        }
        
        [textView, shadowView].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: self.topAnchor),
            textView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textView.heightAnchor.constraint(equalToConstant: 44.0)
        ])
        
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: self.topAnchor),
            shadowView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            shadowView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        shadowView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: shadowView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor)
        ])
        
        setTextViewLayout()
    }
    
    func setTextViewLayout() {
        
        [textLabel, dropDownImageView].forEach {
            textView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            textLabel.centerYAnchor.constraint(equalTo: textView.centerYAnchor),
            textLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 16.0)
        ])
        
        NSLayoutConstraint.activate([
            dropDownImageView.centerYAnchor.constraint(equalTo: textView.centerYAnchor),
            dropDownImageView.trailingAnchor.constraint(equalTo: textView.trailingAnchor,constant: -17),
            dropDownImageView.widthAnchor.constraint(equalToConstant: 10),
            dropDownImageView.heightAnchor.constraint(equalToConstant: 5)
        ])
    }
}
