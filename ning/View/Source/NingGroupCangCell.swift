//
//  GroupCangCell.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/16.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class NingGroupCangCell: BaseTableViewCell {

    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.text
        view.font = UIFont.systemFont(ofSize: 15)
        return view
    }()
    
    lazy var checkImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()

    override func setupUI() {
        self.backgroundColor = UIColor.listItem
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        addSubview(checkImageView)
        checkImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(36)
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
    }

    var model: SourceDir? {
        didSet {
            guard let model = model else { return }
            setItem(name: model.name, checked: model.checked)
        }
    }
    
    var source: SourceModel? {
        didSet {
            guard let source = source else { return }
            setItem(name: source.name, checked: source.checked)
        }
    }
    
    private func setItem(name: String, checked: Bool) {
        nameLabel.text = name
        if checked {
            checkImageView.image = UIImage(named: "checked_radio")
        } else {
            checkImageView.image = UIImage(named: "check_radio")
        }
    }
}
