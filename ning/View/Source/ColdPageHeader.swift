//
//  ColdPageHeader.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/25.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class ColdPageHeader: BaseView {

    lazy var btnView: UILabel = {
        let view = UILabel()
        view.backgroundColor = UIColor.lightTheme
        view.font =  UIFont.systemFont(ofSize: 14)
        view.textAlignment = .left
        view.textColor = UIColor.text
        return view
    }()
    
    override func setupUI() {
        addSubview(btnView)
        btnView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    func setListType(_ listType: NingListType) {
        if listType == .Topic {
            btnView.text = "  精确选择主题有助于提升推荐效果（至少5个）"
        } else {
            btnView.text = "  精确选择站点有助于提升推荐效果（至少2个）"
        }
    }

}
