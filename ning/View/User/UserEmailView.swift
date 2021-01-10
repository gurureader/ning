//
//  UserEmailView.swift
//  ning
//
//  Created by tuicool on 2020/10/21.
//  Copyright © 2020 tuicool. All rights reserved.
//
import TextFieldEffects

class UserEmailView: BaseView {

    lazy var nameView: UITextField = {
        let view = YoshikoTextField()
        view.placeholder = "邮箱地址"
        view.backgroundColor = UIColor.listItem
        view.activeBorderColor = UIColor.theme
        view.autocapitalizationType = .none
        return view
    }()
    
    lazy var codeBodyView : UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var codeView: UITextField = {
        let view = YoshikoTextField()
        view.placeholder = "验证码"
        view.backgroundColor = UIColor.listItem
        view.activeBorderColor = UIColor.theme
        view.autocapitalizationType = .none
        return view
    }()
    
    lazy var checkBtn: UIButton = {
        let view = UIButton()
        view.setTitle("获取验证码", for: .normal)
        view.backgroundColor = UIColor.listItem
        view.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        view.setTitleColor(UIColor.text, for: .normal)
        return view
    }()

    override func setupUI() {
        self.backgroundColor =  UIColor.background
        addSubview(nameView)
        let fieldWidth = 5
        let fieldHeight = 50
        nameView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(fieldWidth)
            make.right.equalToSuperview().offset(-fieldWidth)
            make.height.equalTo(fieldHeight)
            make.top.equalToSuperview().offset(60)
            make.centerX.equalToSuperview()
        }
        
        addSubview(codeBodyView)
        codeBodyView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(fieldWidth)
            make.right.equalToSuperview().offset(-fieldWidth)
            make.height.equalTo(fieldHeight)
            make.top.equalTo(nameView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        codeBodyView.addSubview(checkBtn)
        checkBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.height.equalTo(fieldHeight)
            make.width.equalTo(120)
            make.top.bottom.equalToSuperview()
        }
        
        codeBodyView.addSubview(codeView)
        codeView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalTo(fieldHeight)
            make.right.equalTo(checkBtn.snp.left).offset(-10)
            make.top.bottom.equalToSuperview()
        }
        
    }

}
