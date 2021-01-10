//
//  ManageGroupCell.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/15.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class NingManageGroupCell: BaseTableViewCell {

    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.text
        view.font = UIFont.systemFont(ofSize: 15)
        return view
    }()
    
    lazy var sortImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "sort")
        return view
    }()
    
    override func setupUI() {
        self.backgroundColor = UIColor.listItem
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        addSubview(sortImageView)
        sortImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(36)
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
    }

    var model: SourceDir? {
        didSet {
            guard let model = model else { return }
            nameLabel.text = model.name
        }
    }
}
