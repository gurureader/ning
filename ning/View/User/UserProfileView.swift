//
//  UserProfileView.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/7.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class UserProfileView: BaseTableViewCell {

    lazy var nameView: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.text
        view.text = "头像"
        view.font = UIFont.systemFont(ofSize: 18)
        return view
    }()
    
    lazy var profileView: UIImageView = {
        let view = UIImageView()
        return view
    }()

    override func setupUI() {
        addSubview(nameView)
        nameView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
        
        addSubview(profileView)
        
        profileView.snp.makeConstraints { (make) in
            make.width.height.equalTo(50)
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        }
    
    }
    
    func setProfile(profile :String?) {
        profileView.kf.setImage(urlString: profile, placeholder: UIImage(named: "ning_default_avatar"))
    }
    
}
