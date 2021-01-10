//
//  HotCategoryCell.swift
//  ning
//
//

import UIKit

class NingHotCategoryCell: BaseCollectionViewCell {

    lazy var leftBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.theme
        view.isHidden = true
        return view
    }()
    
    lazy var titleView: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.text
        view.font = UIFont.systemFont(ofSize: 18)
        return view
    }()

    override func setupUI() {
        addSubview(leftBorderView)
        leftBorderView.snp.makeConstraints { (make) in
            make.top.bottom.left.equalToSuperview()
            make.width.equalTo(4)
        }
        
        addSubview(titleView)
        
        titleView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    func setTitle(title :String) {
        titleView.text = title
    }
    
    func setSelected(selected: Bool) {
        if selected {
            leftBorderView.isHidden = false
        } else {
            leftBorderView.isHidden = true
        }
    }
}
