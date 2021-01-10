//
//  NewTuikanView.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/17.
//  Copyright © 2020 tuicool. All rights reserved.
//

import TextFieldEffects

class NewTuikanView: BaseView {
    
    var privateState: Bool = false

    lazy var nameView: UITextField = {
        let view = YoshikoTextField()
        view.placeholder = "收藏夹名称"
        view.backgroundColor = UIColor.listItem
        view.activeBorderColor = UIColor.theme
        view.autocapitalizationType = .none
        return view
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var tipView: UILabel = {
        let view = UILabel()
        view.text = "仅自己可见"
        view.textColor = UIColor.text
        view.font = UIFont.systemFont(ofSize: 14)
        return view
    }()
    
    lazy var checkView: UIButton = {
        let view = UIButton()
        return view
    }()

    override func setupUI() {
        self.backgroundColor =  UIColor.background
        addSubview(nameView)
        let fieldWidth = 5
        nameView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(fieldWidth)
            make.right.equalToSuperview().offset(-fieldWidth)
            make.height.equalTo(50)
            make.top.equalToSuperview().offset(40)
            make.centerX.equalToSuperview()
        }
        addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalTo(nameView.snp.bottom).offset(5)
        }
        bottomView.addSubview(checkView)
        checkView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.width.height.equalTo(40)
            make.centerY.equalToSuperview()
        }
        bottomView.addSubview(tipView)
        tipView.snp.makeConstraints { (make) in
            make.left.equalTo(checkView.snp.right).offset(5)
            make.centerY.equalToSuperview()
        }
        updateCheckButton(false)
        checkView.addTarget(self, action: #selector(updatePrivateState), for: .touchUpInside)
    }
    
    var model: SourceModel? {
        didSet {
            guard let model = model else { return }
            nameView.text = model.name
            updateCheckButton(model.type == 0)
        }
    }
    
    @objc func updatePrivateState() {
        updateCheckButton(!privateState)
    }
    
    private func updateCheckButton(_ isPrivate: Bool = false) {
        if isPrivate{
            checkView.setImage(UIImage(named: "checkbox-checked"), for: .normal)
            privateState = true
        } else {
            checkView.setImage(UIImage(named: "checkbox-unchecked"), for: .normal)
            privateState = false
        }
    }
    

}
