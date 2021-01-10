//
//  ColdSourceCell.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/24.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class NingColdSourceCell: BaseCollectionViewCell {

    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.text
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    override func setupUI() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
        unchoose()
    }

    var model: SourceModel? {
        didSet {
            guard let model = model else { return }
            titleLabel.text = model.name
        }
    }
    
    func choose() {
        titleLabel.textColor = UIColor.white
        titleLabel.backgroundColor = UIColor.theme
        titleLabel.layer.borderColor = UIColor.theme.withAlphaComponent(0.6).cgColor
        titleLabel.layer.borderWidth = 1
    }
    
    func unchoose() {
        titleLabel.textColor = UIColor.text
        titleLabel.backgroundColor = UIColor.listItem
        titleLabel.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
        titleLabel.layer.borderWidth = 1
    }
}
