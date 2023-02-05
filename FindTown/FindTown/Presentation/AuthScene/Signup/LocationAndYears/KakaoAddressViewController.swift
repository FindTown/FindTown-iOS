//
//  KakaoZipViewController.swift
//  FindTown
//
//  Created by 김성훈 on 2022/12/30.
//

import UIKit
import WebKit

import FindTownCore

final class KakaoAddressViewController: BaseWebViewController {
    
    // MARK: - Properties
    
    weak var delegate: LocationAndYearsDelegate?
    
    private var roadAddress = "" /// 도로명 주소
    private var bname = "" /// 법정동/법정리 이름
    private var bname2 = "" /// 법정동/법정리 이름
    private var sido = "" /// 도/시 이름
    private var sigungu = "" /// 시/군/구 이름
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension KakaoAddressViewController {
    override func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
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
