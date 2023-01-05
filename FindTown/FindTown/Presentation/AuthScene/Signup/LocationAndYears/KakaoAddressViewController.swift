//
//  KakaoZipViewController.swift
//  FindTown
//
//  Created by 김성훈 on 2022/12/30.
//

import UIKit
import WebKit

import FindTownCore

final class KakaoAddressViewController: BaseViewController {
    
    // MARK: - Properties
    
    weak var delegate: LocationAndYearsDelegate?
    
    private var roadAddress = "" /// 도로명 주소
    private var bname = "" /// 법정동/법정리 이름
    private var bname2 = "" /// 법정동/법정리 이름
    private var sido = "" /// 도/시 이름
    private var sigungu = "" /// 시/군/구 이름
    
    // MARK: - Views
    
    private var webView: WKWebView?
    private let indicator = UIActivityIndicatorView(style: .medium)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addView() {
        let contentController = WKUserContentController()
        contentController.add(self, name: "callBackHandler")
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController
        
        webView = WKWebView(frame: .zero, configuration: configuration)
        self.webView?.navigationDelegate = self
        
        guard let url = URL(string: "https://ungchun.github.io/Kakao-Postcode/"),
              let webView = webView
        else { return }
        let request = URLRequest(url: url)
        webView.load(request)
        indicator.startAnimating()
        
        view.addSubview(webView)
        webView.addSubview(indicator)
    }
    
    override func setLayout() {
        guard let webView = webView else { return }
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: webView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: webView.centerYAnchor),
        ])
    }
    override func setupView() {
        view.backgroundColor = .white
    }
}

extension KakaoAddressViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let data = message.body as? [String: Any] {
            roadAddress = data["roadAddress"] as? String ?? ""
            bname = data["bname"] as? String ?? ""
            bname2 = data["bname2"] as? String ?? ""
            sido = data["sido"] as? String ?? ""
            sigungu = data["sigungu"] as? String ?? ""
        }
        let address = ("\(sido) \(sigungu) \(bname == "" ? bname2 : bname)")
        delegate?.dismissKakaoAddressWebView(address: address)
        self.dismiss(animated: true, completion: nil)
    }
}

extension KakaoAddressViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
    }
}
