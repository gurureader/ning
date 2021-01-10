//
//  SourceArticleHeader.swift
//  ning
//
//

import UIKit


class SourceArticleHeader: BaseView {
    
    lazy var bgView: UIView = {
        let bw = UIView()
        bw.contentMode = .scaleAspectFill
        bw.backgroundColor = UIColor.theme
        return bw
    }()
    
    lazy var imgView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage()
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        NingUtils.buildBorder(view, color: UIColor.white)
        return view
    }()
    
    lazy var nameView: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.white
        view.font = UIFont.systemFont(ofSize: 16)
        return view
    }()
    
    lazy var followBtn: UIButton = {
        let view = UIButton()
        view.setTitleColor(UIColor.white, for: .normal)
        view.backgroundColor = UIColor.theme
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        view.isUserInteractionEnabled = true
        NingUtils.buildBorder(view, color: UIColor.white, width: 0.3)
        return view
    }()
    
    override func setupUI() {
        addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.width.height.equalTo(60)
            make.top.equalToSuperview().offset(60)
            make.centerX.equalToSuperview()
        }
        
        addSubview(nameView)
        nameView.snp.makeConstraints { (make) in
            make.top.equalTo(imgView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        addSubview(followBtn)
        followBtn.snp.makeConstraints { (make) in
            make.top.equalTo(nameView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
        }
    }
    
    var model: SourceModel? {
        didSet {
            guard let model = model else { return }
            nameView.text = model.name
            if model.image == "juhe" {
                imgView.image = UIImage(named: "juhe")
                followBtn.isHidden = true
            } else {
                logInfo("model follow=\(model.followed)")
                imgView.kf.setImage(urlString: model.image, placeholder: UIImage(named: "default_site"))
                if model.followed && DAOFactory.isLogin() {
                    followBtn.setTitle("取消关注", for: .normal)
                } else {
                    followBtn.setTitle("添加关注", for: .normal)
                }
                followBtn.isHidden = false
            }
            
        }
    }
    
}
