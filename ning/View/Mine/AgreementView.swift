//
//  AgreementView.swift
//  ning
//
//

import UIKit

class AgreementView: BaseView {
    
    lazy var titleView: UILabel = {
        let textView = UILabel()
        textView.text = "用户协议与隐私政策"
        textView.textColor = UIColor.text
        textView.font = UIFont.systemFont(ofSize: 18)
        return textView
    }()

    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isUserInteractionEnabled = true
        textView.textColor = UIColor.text
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.text = ""
        textView.appendLinkString(string: "GuruReader仅会将您的信息用于提供服务，我们将保障您的信息安全和隐私，请同意后使用。如果您不同意，很遗憾我们无法为您服务。您可以通过阅读")
        textView.appendLinkString(string: "《用户协议》", withURLString: "https://api.\(DOMAIN_MAIN)/misc/agreement")
        textView.appendLinkString(string: "和")
        textView.appendLinkString(string: "《隐私政策》", withURLString: "https://api.\(DOMAIN_MAIN)/misc/privacy")
           textView.appendLinkString(string: "了解相关服务。")
        return textView
    }()
    
    lazy var btnView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var noView: UIButton = {
        let view = UIButton()
        view.setTitle("不同意退出", for: .normal)
        view.backgroundColor = UIColor.lightGray
        view.titleLabel?.textColor = UIColor.white
        view.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return view
    }()
    
    lazy var yesView: UIButton = {
        let view = UIButton()
        view.setTitle("同意并继续", for: .normal)
        view.backgroundColor = UIColor.theme
        view.titleLabel?.textColor = UIColor.white
        view.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return view
    }()
    
    override func setupUI() {
        self.backgroundColor = UIColor.white
        addSubview(titleView)
        titleView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
        }
        addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom).offset(20)
            make.width.equalTo(280)
            make.height.equalTo(100)
            make.centerX.equalToSuperview()
        }
        btnView.addSubview(noView)
        noView.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalToSuperview()
            make.left.equalToSuperview()
        }
        btnView.addSubview(yesView)
        yesView.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalToSuperview()
            make.right.equalToSuperview()
        }
        addSubview(btnView)
        btnView.snp.makeConstraints { (make) in
            make.top.equalTo(textView.snp.bottom).offset(20)
            make.width.equalTo(230)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
    }

}
