//
//  File.swift
//  
//
//  Created by 김성훈 on 2023/02/05.
//

import UIKit
import WebKit

open class BaseWebViewController: UIViewController {
    
    private var webViewTitle: String?
    private var url: String?
    private var callBackKey: String?
    
    private lazy var webView: WKWebView = {
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = true
        
        let contentController = WKUserContentController()
        contentController.add(self, name: self.callBackKey ?? "")
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController
        
        let webView = WKWebView(frame: self.view.bounds, configuration: configuration)
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        return webView
    }()
    
    public let indicator = UIActivityIndicatorView(style: .medium)
    
    public init(webViewTitle: String?, url: String?, callBackKey: String = "") {
        self.webViewTitle = webViewTitle
        self.url = url
        self.callBackKey = callBackKey
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        addView()
        setLayout()
        setupView()
    }
    
    private func addView() {
        view.addSubview(webView)
        webView.addSubview(indicator)
    }
    
    private func setLayout() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: webView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: webView.centerYAnchor),
        ])
    }
    
    private func setupView() {
        indicator.startAnimating()
        
        self.navigationItem.title = webViewTitle
        
        guard let url = URL(string: url ?? "https://www.naver.com/") else { return }
        let request = URLRequest(url: url)
        webView.scrollView.delegate = self
        webView.navigationDelegate = self
        webView.load(request)
    }
}

extension BaseWebViewController: UIScrollViewDelegate {
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}

extension BaseWebViewController: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicator.startAnimating()
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
    }
}

extension BaseWebViewController: WKScriptMessageHandler {
    
    open func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    }
}
