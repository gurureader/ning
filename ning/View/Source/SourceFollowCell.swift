//
//  SourceFollowCell.swift
//  ning
//
//

import UIKit

class SourceFollowCell: BaseTableViewCell {
    
    lazy var imgView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "default_site")
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()

    lazy var nameView: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.text
        view.font = UIFont.systemFont(ofSize: 16)
        return view
    }()
    
    lazy var followView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "follow")
        return view
    }()

    override func setupUI() {
        
        addSubview(imgView)
        
        imgView.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        addSubview(nameView)
        nameView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            make.centerY.equalToSuperview()
        }
        
        addSubview(followView)
        followView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(followView.snp.height)
        }
        followView.isUserInteractionEnabled = true
    }
    
    var model: SourceModel? {
        didSet {
            guard let model = model else { return }
            imgView.kf.setImage(urlString:model.image, placeholder: UIImage(named: "default_site"))
            nameView.text = model.name
            if model.followed {
                followView.image = UIImage(named: "followed")
            } else {
                followView.image = UIImage(named: "follow")
            }
        }
    }


}
