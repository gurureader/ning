//
//  ManageTuikanView.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/19.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class ManageTuikanView: BaseTableViewCell {

    private  lazy var nameLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.text
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        return titleLabel
    }()
    
    lazy var countLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.text
        view.font = UIFont.systemFont(ofSize: 11)
        view.backgroundColor = UIColor.unreadNumBg
        view.textColor = UIColor.unreadNumText
        view.clipsToBounds = true
        view.layer.cornerRadius = 11
        view.textAlignment = .center
        return view
    }()
    
    lazy var editBtn: UIButton = {
        let view = UIButton()
        view.setTitle("修改", for: .normal)
        view.backgroundColor = UIColor.theme
        view.titleLabel?.textColor = UIColor.white
        view.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return view
    }()
    
    lazy var transferBtn: UIButton = {
        let view = UIButton()
        view.setTitle("迁移", for: .normal)
        view.backgroundColor = UIColor.theme
        view.titleLabel?.textColor = UIColor.white
        view.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return view
    }()
    
    lazy var removeBtn: UIButton = {
        let view = UIButton()
        view.setTitle("删除", for: .normal)
        view.backgroundColor = UIColor.red
        view.titleLabel?.textColor = UIColor.white
        view.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return view
    }()
    
    override func setupUI() {
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.right).offset(5)
            make.height.width.equalTo(22)
            make.centerY.equalToSuperview()
        }
        let width = 50
        contentView.addSubview(removeBtn)
        removeBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-5)
            make.width.equalTo(width)
            make.height.equalTo(25)
            make.centerY.equalToSuperview()
        }
        
//        contentView.addSubview(transferBtn)
//        transferBtn.snp.makeConstraints { make in
//            make.right.equalTo(removeBtn.snp.left).offset(-5)
//            make.width.equalTo(width)
//            make.height.equalTo(25)
//            make.centerY.equalToSuperview()
//        }
        
        contentView.addSubview(editBtn)
        editBtn.snp.makeConstraints { make in
            make.right.equalTo(removeBtn.snp.left).offset(-5)
            make.width.equalTo(width)
            make.height.equalTo(25)
            make.centerY.equalToSuperview()
        }
    }
    
    var model: SourceModel? {
        didSet {
            guard let model = model else { return }
            nameLabel.text = model.name
            countLabel.text = String(model.ac)
        }
    }
}
