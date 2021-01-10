//
//  UserFieldView.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/7.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class UserFieldView: BaseTableViewCell {

    lazy var nameView: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.text
        view.font = UIFont.systemFont(ofSize: 18)
        return view
    }()
    
    lazy var valueView: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.lightGray
        view.font = UIFont.systemFont(ofSize: 18)
        return view
    }()

    override func setupUI() {
        addSubview(nameView)
        nameView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
        
        addSubview(valueView)
        
        valueView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        }
    
    }
    
    func setValue(name: String, value :String) {
        nameView.text = name
        valueView.text = value
    }
}
