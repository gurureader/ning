//
//  MemberView.swift
//  ning
//
//  Created by tuicool on 2020/11/14.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit
import WebKit

class MemberView: BaseView {

    lazy var payView: MemberPayView = {
        let view = MemberPayView()
        return view
    }()
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    lazy var webView: WKWebView = {
        return buildWebView()
    }()
    
    
    lazy var submitView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.listItem
        return view
    }()
    
    lazy var submitBtn: UIButton = {
        let view = UIButton()
        view.setTitle("支付", for: .normal)
        view.backgroundColor = UIColor.theme
        view.titleLabel?.textColor = UIColor.white
        return view
    }()
    
    private func buildWebView() -> WKWebView {
        let webView = WKWebView()
        webView.allowsBackForwardNavigationGestures = false
        webView.isMultipleTouchEnabled = false
        return webView
    }
    
    override func setupUI() {
        self.backgroundColor = UIColor.background
        payView.setupUI(self)
        addSubview(submitView)
        submitView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.top.equalTo(payView.views[2].snp.bottom).offset(1)
            make.height.equalTo(60)
        }
        submitView.addSubview(submitBtn)
        submitBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
            make.top.equalTo(submitView.snp.bottom).offset(24)
        }
        scrollView.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    var model: MemberInfo? {
        didSet {
            guard let model = model else { return }
            let html = buildHtml(model)
            webView.loadHTMLString(html, baseURL: nil)
            payView.moneys[0].text = model.year_money
            payView.moneys[1].text = model.half_year_money
            payView.moneys[2].text = model.quart_money
        }
    }
    
    func buildHtml(_ model: MemberInfo) -> String {
        guard let htmlFile = Bundle.main.path(forResource: "member", ofType: "html") else { return "" }
        do {
            let htmlContent = try String(contentsOfFile: htmlFile, encoding: String.Encoding.utf8)
            var logs = ""
            if !model.logs.isEmpty {
                logs = "<h3>会员记录</h3><div>\(model.logs)</div>"
            }
            let html = String(format: htmlContent, logs,model.service,model.help)
            return html
        } catch {
            return ""
        }
        
    }
}
