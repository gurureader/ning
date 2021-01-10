//
//  NewGroupView.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/14.
//  Copyright © 2020 tuicool. All rights reserved.
//

import TextFieldEffects

class NingNewGroupView: BaseView {

    lazy var nameView: UITextField = {
        let view = YoshikoTextField()
        view.placeholder = "收藏夹名称"
        view.backgroundColor = UIColor.listItem
        view.activeBorderColor = UIColor.theme
        view.autocapitalizationType = .none
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
            make.top.equalToSuperview().offset(60)
            make.centerX.equalToSuperview()
        }
    }
    
}
