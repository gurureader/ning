//
//  NewUserFormView.swift
//  ning
//
//  Created by JianjiaYu on 2020/10/10.
//  Copyright © 2020 tuicool. All rights reserved.
//

import TextFieldEffects

class NewUserFormView: BaseView {
    
    lazy var nameView: UITextField = {
        let view = HoshiTextField()
        view.placeholder = "用户名"
        view.borderInactiveColor = UIColor.lightGray
        view.borderActiveColor = UIColor.theme
        view.placeholderColor = UIColor.lightGray
        view.autocapitalizationType = .none
        return view
    }()

    lazy var emailView: UITextField = {
        let view = HoshiTextField()
        view.placeholder = "邮箱"
        view.borderInactiveColor = UIColor.lightGray
        view.borderActiveColor = UIColor.theme
        view.placeholderColor = UIColor.lightGray
        view.autocapitalizationType = .none
        return view
    }()

    lazy var passView: UITextField = {
        let view = HoshiTextField()
        view.placeholder = "密码(最少8位)"
        view.isSecureTextEntry = true
        view.borderInactiveColor = UIColor.lightGray
        view.borderActiveColor = UIColor.theme
        view.placeholderColor = UIColor.lightGray
        view.autocapitalizationType = .none
        return view
    }()
    
    lazy var againView: UITextField = {
        let view = HoshiTextField()
        view.placeholder = "重复密码"
        view.isSecureTextEntry = true
        view.borderInactiveColor = UIColor.lightGray
        view.borderActiveColor = UIColor.theme
        view.placeholderColor = UIColor.lightGray
        view.autocapitalizationType = .none

        return view
    }()
    
    lazy var codeBodyView : UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var codeView: UITextField = {
        let view = HoshiTextField()
        view.placeholder = "验证码"
        view.borderInactiveColor = UIColor.lightGray
        view.borderActiveColor = UIColor.theme
        view.placeholderColor = UIColor.lightGray
        view.autocapitalizationType = .none
        return view
    }()
    
    lazy var checkBtn: UIButton = {
        let view = UIButton()
        view.setTitle("获取验证码", for: .normal)
        view.backgroundColor = UIColor.background
        view.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        view.setTitleColor(UIColor.text, for: .normal)
        return view
    }()
    
    lazy var submtBtn: UIButton = {
        let view = UIButton()
        view.setTitle("注册", for: .normal)
        view.backgroundColor = UIColor.theme
        view.setTitleColor(UIColor.white, for: .normal)
        return view
    }()
    
    override func setupUI() {
        let fieldWidth = 30
        let fieldHeight = 50
        let offset = 10
        self.backgroundColor = UIColor.listItem
        addSubview(nameView)
        nameView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(fieldWidth)
            make.right.equalToSuperview().offset(-fieldWidth)
            make.height.equalTo(fieldHeight)
            make.top.equalToSuperview().offset(40)
            make.centerX.equalToSuperview()
        }
        
        addSubview(emailView)
        emailView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(fieldWidth)
            make.right.equalToSuperview().offset(-fieldWidth)
            make.height.equalTo(fieldHeight)
            make.top.equalTo(nameView.snp.bottom).offset(offset)
            make.centerX.equalToSuperview()
        }
        
        addSubview(passView)
        passView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(fieldWidth)
            make.right.equalToSuperview().offset(-fieldWidth)
            make.height.equalTo(fieldHeight)
            make.top.equalTo(emailView.snp.bottom).offset(offset)
            make.centerX.equalToSuperview()
        }
        
        addSubview(againView)
        againView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(fieldWidth)
            make.right.equalToSuperview().offset(-fieldWidth)
            make.height.equalTo(fieldHeight)
            make.top.equalTo(passView.snp.bottom).offset(offset)
            make.centerX.equalToSuperview()
        }
        
        addSubview(codeBodyView)
        codeBodyView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(fieldWidth)
            make.right.equalToSuperview().offset(-fieldWidth)
            make.height.equalTo(fieldHeight)
            make.top.equalTo(againView.snp.bottom).offset(offset)
            make.centerX.equalToSuperview()
        }
        
        codeBodyView.addSubview(codeView)
        codeView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalTo(fieldHeight)
            make.width.equalTo(200)
            make.top.bottom.equalToSuperview()
        }
        
        codeBodyView.addSubview(checkBtn)
        checkBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.height.equalTo(fieldHeight)
            make.left.equalTo(codeView.snp.right).offset(10)
            make.top.bottom.equalToSuperview()
        }
        
        addSubview(submtBtn)
        submtBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(fieldWidth)
            make.right.equalToSuperview().offset(-fieldWidth)
            make.height.equalTo(fieldHeight)
            make.top.equalTo(codeBodyView.snp.bottom).offset(offset)
            make.centerX.equalToSuperview()
        }
    }
}
