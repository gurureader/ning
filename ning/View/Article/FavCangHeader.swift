//
//  FavCangHeader.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/17.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class FavCangHeader: BaseView {

    lazy var btnView: UIButton = {
        let view = UIButton()
        view.setTitle("+创建收藏夹", for: .normal)
        view.backgroundColor = UIColor.listItem
        view.setTitleColor(UIColor.lightGray, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        view.titleLabel?.textAlignment = .center
        return view
    }()
    
    override func setupUI() {
        addSubview(btnView)
        btnView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
