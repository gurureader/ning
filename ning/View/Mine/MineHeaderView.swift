//
//  MineHeaderView.swift
//  ning
//
//

import UIKit

class MineHeaderView: BaseView {
    
    lazy var bgView: UIView = {
        let bw = UIView()
        bw.contentMode = .scaleAspectFill
        bw.backgroundColor = UIColor.theme
        return bw
    }()
    
    lazy var profileView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ning_default_avatar")
        view.layer.cornerRadius = 40
        view.clipsToBounds = true
        NingUtils.buildBorder(view, color: UIColor.white)
        return view
    }()
    
    lazy var nameView: UILabel = {
        let view = UILabel()
        view.text = "点击登录"
        view.textColor = UIColor.white
        view.font = UIFont.systemFont(ofSize: 18)
        return view
    }()
    
    lazy var memberView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "member")
        return view
    }()
    
    override func setupUI() {
        addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        addSubview(profileView)
        
        profileView.snp.makeConstraints { (make) in
            make.width.height.equalTo(80)
            make.top.equalToSuperview().offset(80)
            make.centerX.equalToSuperview()
        }
        
        addSubview(nameView)
        
        nameView.snp.makeConstraints { (make) in
            make.top.equalTo(profileView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
        
        addSubview(memberView)
        
        memberView.snp.makeConstraints { (make) in
            make.top.equalTo(profileView.snp.bottom).offset(15)
            make.width.height.equalTo(20)
            make.left.equalTo(nameView.snp.right).offset(5)
        }
        memberView.isHidden = true
    }
    
    func setClickAction(_ target: Any, action: Selector?) {
        let gesture = UITapGestureRecognizer(target: target, action:action)
        gesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(gesture)
    }
    
    var model: UserInfo? {
        didSet {
            guard let model = model else { return }
            if !model.isLogin() {
                return
            }
            nameView.text = model.name
            profileView.kf.setImage(urlString: model.profile, placeholder: UIImage(named: "ning_default_avatar"))
            if model.is_member {
                memberView.isHidden = false
            } else {
                memberView.isHidden = true
            }
        }
    }
}
