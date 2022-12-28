//
//  File.swift
//  
//
//  Created by 김성훈 on 2022/12/28.
//

import UIKit

open class BaseBottomSheetViewController: BaseViewController {
    
    enum BottomSheetStatus {
        case show
        case hide
    }
    
    var bottomHeight: CGFloat
    private var bottomSheetViewTopConstraint: NSLayoutConstraint!
    
    private lazy var dimmedBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.0
        return view
    }()
    
    public lazy var bottomSheetView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 27
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var dismissIndicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray2
        view.layer.cornerRadius = 3
        return view
    }()
    
    public init(bottomHeight: CGFloat) {
         self.bottomHeight = bottomHeight
         super.init(nibName: nil, bundle: nil)
     }
     
    required public init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupGestureRecognizer()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setBottomSheetStatus(to: .show)
    }
    
    open override func addView() {
        [dimmedBackView, bottomSheetView, dismissIndicatorView].forEach {
            view.addSubview($0)
        }
    }
    
    open override func setLayout() {
        NSLayoutConstraint.activate([
            dimmedBackView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedBackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedBackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmedBackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        let top = window?.safeAreaInsets.top ?? 0
        let bottom = window?.safeAreaInsets.bottom ?? 0
        
        let topConstant = view.safeAreaInsets.bottom + view.safeAreaLayoutGuide.layoutFrame.height
        bottomSheetViewTopConstraint = bottomSheetView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstant - top - bottom
        )
        NSLayoutConstraint.activate([
            bottomSheetView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomSheetView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomSheetViewTopConstraint
        ])
        
        NSLayoutConstraint.activate([
            dismissIndicatorView.widthAnchor.constraint(equalToConstant: 100),
            dismissIndicatorView.heightAnchor.constraint(equalToConstant: 7),
            dismissIndicatorView.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 10),
            dismissIndicatorView.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor)
        ])
    }
    
    private func setupGestureRecognizer() {
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        dimmedBackView.addGestureRecognizer(dimmedTap)
        dimmedBackView.isUserInteractionEnabled = true
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(panGesture))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }
    
    private func setBottomSheetStatus(to status: BottomSheetStatus) {
        let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding: CGFloat = view.safeAreaInsets.bottom
        
        switch status {
        case .show:
            bottomSheetViewTopConstraint.constant = (safeAreaHeight + bottomPadding) - bottomHeight
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
                self.dimmedBackView.alpha = 0.5
                self.view.layoutIfNeeded()
            }, completion: nil)
        case .hide:
            bottomSheetViewTopConstraint.constant = safeAreaHeight + bottomPadding
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
                self.dimmedBackView.alpha = 0.0
                self.view.layoutIfNeeded()
            }) { _ in
                if self.presentingViewController != nil {
                    self.dismiss(animated: false, completion: nil)
                }
            }
        }
    }
    
    @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        setBottomSheetStatus(to: .hide)
    }
    
    @objc private func panGesture(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .ended {
            switch recognizer.direction {
            case .down:
                setBottomSheetStatus(to: .hide)
            default:
                break
            }
        }
    }
}
