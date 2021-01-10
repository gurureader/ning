//
//  KeywordItemCell.swift
//  ning
//
//

import UIKit
import TextFieldEffects

class KeywordRuleItemCell: BaseTableViewCell {

    lazy var kwText: UITextField = {
        let view = YoshikoTextField()
        view.placeholder = "匹配的关键词"
        view.backgroundColor = UIColor.listItem
        view.activeBorderColor = UIColor.theme
        view.autocapitalizationType = .none
        return view
    }()
    
    lazy var opBtn: UIButton = {
        let view = UIButton()
        view.setTitle("与关系", for: .normal)
        view.backgroundColor = UIColor.background
        view.setTitleColor(UIColor.text, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return view
    }()
    
    lazy var deleteBtn: UIButton = {
        let view = UIButton()
        view.setTitle("删除", for: .normal)
        view.backgroundColor = UIColor.background
        view.setTitleColor(UIColor.text, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return view
    }()
    
    func setupUI1() {
        addSubview(deleteBtn)
        let height = 35
        deleteBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.width.equalTo(70)
            make.height.equalTo(height)
            make.centerY.equalToSuperview()
        }
        addSubview(opBtn)
        opBtn.snp.makeConstraints { (make) in
            make.left.equalTo(deleteBtn.snp.right).offset(8)
            make.width.equalTo(70)
            make.height.equalTo(height)
            make.centerY.equalToSuperview()
        }
//        addSubview(kwText)
//        kwText.snp.makeConstraints { (make) in
//            make.left.equalToSuperview().offset(12)
//            make.right.equalTo(opBtn.snp.left).offset(-8)
//            make.centerY.equalToSuperview()
//            make.height.equalTo(height)
//        }
    }
    
    override func setupUI() {
        contentView.addSubview(deleteBtn)
        let height = 35
        deleteBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-12)
            make.width.equalTo(70)
            make.height.equalTo(height)
            make.centerY.equalToSuperview()
        }
        contentView.addSubview(opBtn)
        opBtn.snp.makeConstraints { (make) in
            make.right.equalTo(deleteBtn.snp.left).offset(-8)
            make.width.equalTo(70)
            make.height.equalTo(height)
            make.centerY.equalToSuperview()
        }
        contentView.addSubview(kwText)
        kwText.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.right.equalTo(opBtn.snp.left).offset(-8)
            make.centerY.equalToSuperview()
            make.height.equalTo(height)
        }
    }

    var model: KeywordRuleItem? {
        didSet {
            guard let model = model else { return }
            kwText.text = model.kw
            if model.op == 0 {
                opBtn.setTitle("或关系", for: .normal)
            } else {
                opBtn.setTitle("与关系", for: .normal)
            }
        }
    }
}
