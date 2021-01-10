//
//  ArticleViewCell.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/4.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class ArticleViewCell: BaseTableViewCell {
    
    private lazy var coverView: UIImageView = {
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFill
        iconView.clipsToBounds = true
        return iconView
    }()
    
    private  lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.text
        return titleLabel
    }()
    
    private lazy var tipLabel: UILabel = {
        let subTitleLabel = UILabel()
        subTitleLabel.textColor = UIColor.lightGray
        subTitleLabel.font = UIFont.systemFont(ofSize: 14)
        return subTitleLabel
    }()
    
    override func setupUI() {
        separatorInset = .zero
        
        contentView.addSubview(coverView)
        coverView.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
            make.width.equalTo(100)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.right.equalTo(coverView.snp.left).offset(-10)
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(48)
            make.top.equalTo(coverView)
        }
        titleLabel.numberOfLines = 2
        
        contentView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { make in
            make.right.equalTo(coverView.snp.left).offset(-10)
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    var model: Article? {
        didSet {
            guard let model = model else { return }
            if  model.img.isEmpty {
                coverView.image = UIImage(named: "abs_image_no")
            } else {
                coverView.kf.setImage(urlString: model.img, placeholder: UIImage(named: "abs_image"))
            }
            titleLabel.text = model.title
            tipLabel.text = model.feed_title + " " + model.getShowTinme()
            if (DAOFactory.articleReadDAO.contains(model.id)) {
                titleLabel.textColor = UIColor.lightGray
            } else {
                titleLabel.textColor = UIColor.text
            }
        }
    }

}
