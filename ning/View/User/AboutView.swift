//
//  AboutView.swift
//  ning
//
//  Created by JianjiaYu on 2020/10/10.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class AboutView: BaseView {

    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isUserInteractionEnabled = true
        textView.textColor = UIColor.text
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 10
                //样式属性集合
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17),
                          NSAttributedString.Key.paragraphStyle: paraph]
        textView.attributedText = NSAttributedString(string: "GuruReader是面向科技领域的聚合阅读APP，内容和功能还在完善中。使用过程中如果遇到问题，可以发邮件到 zhouyu@gurureader.cn。", attributes: attributes)
        return textView
    }()
    
    override func setupUI() {
        addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(40)
            make.left.right.bottom.equalToSuperview()
        }
        textView.backgroundColor = UIColor.background
    }
}
