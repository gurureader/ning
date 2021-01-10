//
//  LoginView.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/6.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit
import TextFieldEffects

class LoginView: BaseView {
    
    lazy var emailView: UITextField = {
        let view = HoshiTextField()
        view.placeholder = "请输入邮箱"
        view.borderInactiveColor = UIColor.lightGray
        view.borderActiveColor = UIColor.theme
        view.placeholderColor = UIColor.lightGray
        view.autocapitalizationType = .none
        return view
    }()
    
    lazy var passwordView: UITextField = {
        let view = HoshiTextField()
        view.isSecureTextEntry = true
        view.placeholder = "请输入密码"
        view.borderInactiveColor = UIColor.lightGray
        view.borderActiveColor = UIColor.theme
        view.placeholderColor = UIColor.lightGray
        view.autocapitalizationType = .none
        return view
    }()
    
    lazy var submitView: UIButton = {
        let view = UIButton()
        view.setTitle("登录", for: .normal)
        view.backgroundColor = UIColor.theme
        view.titleLabel?.textColor = UIColor.white
        return view
    }()
    
    lazy var thirdTipView : UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var thirdTipLeftLine : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    lazy var thirdTipRightLine : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    lazy var thirdTipText : UILabel = {
        let view = UILabel()
        view.text = "其他方式登录"
        view.textColor = UIColor.lightGray
        view.font = UIFont.systemFont(ofSize: 14)
        view.textAlignment = .center
        return view
    }()
    
    lazy var weixinView: UIButton = {
        let view = UIButton()
        view.setTitle("使用微信登录", for: .normal)
        view.backgroundColor = UIColor.weixin
        view.titleLabel?.textColor = UIColor.white
        return view
    }()

    override func setupUI() {
        let fieldWidth = 30
        let fieldHeight = 50
        let offset = 10
        self.backgroundColor = UIColor.listItem
        addSubview(emailView)
        emailView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(fieldWidth)
            make.right.equalToSuperview().offset(-fieldWidth)
            make.height.equalTo(fieldHeight)
            make.top.equalToSuperview().offset(60)
            make.centerX.equalToSuperview()
        }
        
        addSubview(passwordView)
        passwordView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(fieldWidth)
            make.right.equalToSuperview().offset(-fieldWidth)
            make.height.equalTo(fieldHeight)
            make.top.equalTo(emailView.snp.bottom).offset(offset)
            make.centerX.equalToSuperview()
        }
        
        addSubview(submitView)
        submitView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(fieldWidth)
            make.right.equalToSuperview().offset(-fieldWidth)
            make.height.equalTo(fieldHeight)
            make.top.equalTo(passwordView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        addSubview(thirdTipView)
        thirdTipView.snp.makeConstraints { (make) in
            make.height.equalTo(fieldHeight)
            make.top.equalTo(submitView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
        }
        
        thirdTipView.addSubview(thirdTipLeftLine)
        thirdTipLeftLine.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(0)
            make.height.equalTo(1)
            make.width.equalTo(90)
            make.centerY.equalToSuperview()
        }
        
        thirdTipView.addSubview(thirdTipText)
        thirdTipText.snp.makeConstraints { (make) in
            make.left.equalTo(thirdTipLeftLine.snp.right)
            make.width.equalTo(120)
            make.height.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        thirdTipView.addSubview(thirdTipRightLine)
        thirdTipRightLine.snp.makeConstraints { (make) in
            make.left.equalTo(thirdTipText.snp.right)
            make.centerY.equalToSuperview()
            make.height.equalTo(1)
            make.width.equalTo(90)
        }
        
        addSubview(weixinView)
        weixinView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(fieldWidth)
            make.right.equalToSuperview().offset(-fieldWidth)
            make.height.equalTo(fieldHeight)
            make.top.equalTo(thirdTipView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
    }
    
    
}
