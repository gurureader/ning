//
//  UserPasswordView.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/15.
//  Copyright © 2020 tuicool. All rights reserved.
//

import TextFieldEffects

class UserPasswordView: BaseView {

    lazy var oldView: UITextField = {
        let view = YoshikoTextField()
        view.placeholder = "当前密码(未设置则不填)"
        view.backgroundColor = UIColor.listItem
        view.activeBorderColor = UIColor.theme
        view.autocapitalizationType = .none
        view.isSecureTextEntry = true
        return view
    }()
    
    lazy var newView: UITextField = {
        let view = YoshikoTextField()
        view.placeholder = "新密码(最少8位)"
        view.backgroundColor = UIColor.listItem
        view.activeBorderColor = UIColor.theme
        view.autocapitalizationType = .none
        view.isSecureTextEntry = true
        return view
    }()
    
    lazy var againView: UITextField = {
        let view = YoshikoTextField()
        view.placeholder = "重复密码"
        view.backgroundColor = UIColor.listItem
        view.activeBorderColor = UIColor.theme
        view.autocapitalizationType = .none
        view.isSecureTextEntry = true
        return view
    }()

    override func setupUI() {
        self.backgroundColor =  UIColor.background
        addSubview(oldView)
        let fieldWidth = 5
        let height = 50
        let offset = 15
        oldView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(fieldWidth)
            make.right.equalToSuperview().offset(-fieldWidth)
            make.height.equalTo(height)
            make.top.equalToSuperview().offset(60)
        }
        addSubview(newView)
        newView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().offset(fieldWidth)
            make.right.equalToSuperview().offset(-fieldWidth)
            make.height.equalTo(height)
            make.top.equalTo(oldView.snp.bottom).offset(offset)
        }
        addSubview(againView)
        againView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(fieldWidth)
            make.right.equalToSuperview().offset(-fieldWidth)
            make.height.equalTo(height)
            make.top.equalTo(newView.snp.bottom).offset(offset)
        }
    }

}
