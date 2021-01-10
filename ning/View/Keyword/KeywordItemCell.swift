//
//  KeywordItemCell.swift
//  ning
//
//

import UIKit

class KeywordItemCell: BaseTableViewCell {

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
    
    override func setupUI() {
        self.backgroundColor = UIColor.listItem
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(12)
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
        }
    }
}
