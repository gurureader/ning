//
//  KeywordRuleHeader.swift
//  ning
//
//

import UIKit
import TextFieldEffects

class KeywordRuleHeader: BaseView {
    
    lazy var descView: UIView = {
        let view = UIView()
        return view
    }()

    lazy var descLabel: UILabel = {
        let view = UILabel()
        view.font =  UIFont.systemFont(ofSize: 14)
        view.textAlignment = .left
        view.textColor = UIColor.theme
        view.text = "查看使用说明"
        return view
    }()
    
    lazy var nameView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.font =  UIFont.systemFont(ofSize: 14)
        view.textAlignment = .left
        view.textColor = UIColor.text
        view.text = "配置名称"
        return view
    }()
    
    lazy var nameText: UITextField = {
        let view = YoshikoTextField()
        view.placeholder = "字符数2-20"
        view.backgroundColor = UIColor.listItem
        view.activeBorderColor = UIColor.theme
        view.autocapitalizationType = .none
        return view
    }()
    
    lazy var langView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var langLabel: UILabel = {
        let view = UILabel()
        view.font =  UIFont.systemFont(ofSize: 14)
        view.textAlignment = .left
        view.textColor = UIColor.text
        view.text = "数据来源"
        return view
    }()
    
    lazy var langBtn: UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColor.background
        view.setTitleColor(UIColor.text, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return view
    }()
    
    
    lazy var ruleView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var ruleLabel: UILabel = {
        let view = UILabel()
        view.font =  UIFont.systemFont(ofSize: 14)
        view.textAlignment = .left
        view.textColor = UIColor.text
        view.text = "配置规则"
        return view
    }()
    
    lazy var ruleBtn: UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColor.background
        view.setTitleColor(UIColor.text, for: .normal)
        view.setTitle("添加", for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return view
    }()
    
    override func setupUI() {
        self.backgroundColor = UIColor.white
        let height = 50
        let itemHeight = 40
        addSubview(descView)
        buildContainerView(descView,height: height,topView: nil)
        descView.addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.height.equalToSuperview()
        }
        
        addSubview(nameView)
        buildContainerView(nameView,height: height,topView: descView)
        nameView.addSubview(nameLabel)
        buildNameLabel(nameLabel,height: itemHeight)
        nameView.addSubview(nameText)
        nameText.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(itemHeight)
        }

        addSubview(langView)
        buildContainerView(langView,height: height,topView: nameView)
        langView.addSubview(langLabel)
        buildNameLabel(langLabel,height: itemHeight)
        langView.addSubview(langBtn)
        langBtn.snp.makeConstraints { (make) in
            make.left.equalTo(langLabel.snp.right)
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.height.equalTo(itemHeight)
        }
        
        addSubview(ruleView)
        buildContainerView(ruleView,height: height,topView: langView)
        ruleView.addSubview(ruleLabel)
        buildNameLabel(ruleLabel,height: itemHeight)
        ruleView.addSubview(ruleBtn)
        ruleBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.height.equalTo(itemHeight)
            make.width.equalTo(80)
        }
    }
    
    private func buildNameLabel(_ view :UILabel, height: Int) {
        view.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.width.equalTo(80)
            make.height.equalTo(height)
            make.centerY.equalToSuperview()
        }
    }
    
    private func buildContainerView(_ view :UIView, height: Int, topView: UIView?) {
        view.snp.makeConstraints { (make) in
            make.height.equalTo(height)
            make.width.equalToSuperview()
            if topView != nil {
                make.top.equalTo(topView!.snp.bottom)
            }  else {
                make.top.equalToSuperview()
            }
        }
    }

    var model: Keyword? {
        didSet {
            guard let model = model else { return }
            nameText.text = model.name
            langBtn.setTitle(Keyword.langName(model.lang), for: .normal)
        }
    }
}
