//
//  ColdSourceHeader.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/24.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class ColdSourceHeader: BaseCollectionReusableView {

    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.text
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    override func setupUI() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
    }

    var model: SourceDir? {
        didSet {
            guard let model = model else { return }
            titleLabel.text = model.name
        }
    }

}
