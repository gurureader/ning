//
//  GroupItemCell.swift
//  ning
//
//

import UIKit

class NingGroupItemCell: BaseTableViewCell {

    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.text
        view.font = UIFont.systemFont(ofSize: 15)
        return view
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
    
    lazy var headImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "default_site")
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        NingUtils.buildGrayBorder(view)
        return view
    }()
    
    override func setupUI() {
        self.backgroundColor = UIColor.listItem
        addSubview(headImageView)
        headImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(46)
            make.centerY.equalToSuperview()
        }
        
        addSubview(countLabel)
        countLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.width.height.equalTo(22)
            make.centerY.equalToSuperview()
        }
        
    }

    var model: SourceModel? {
        didSet {
            guard let model = model else { return }
            nameLabel.text = model.name
            if model.cnt > 0 {
                countLabel.text = String(model.cnt)
                countLabel.isHidden = false
            } else {
                countLabel.isHidden = true
            }
            headImageView.kf.setImage(urlString: model.image, placeholder: UIImage(named: "default_site"))
        }
    }
}
