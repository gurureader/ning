//
//  MemberPayView.swift
//  ning
//
//  Created by tuicool on 2020/11/15.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class MemberPayView {

    var views = Array<UIView>()
    var checks = Array<UIImageView>()
    var moneys = Array<UILabel>()
    
    func setupUI(_ view: UIView) {
        let yearMoney = buildLineView("年度会员",nil,view)
        let halfMoney = buildLineView("半年会员",yearMoney,view)
        _ = buildLineView("季度会员",halfMoney,view)
    }
    
    private func buildLineView(_ text: String, _ topView: UIView?, _ parentView: UIView) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.listItem
        parentView.addSubview(view)
        let textView = UILabel()
        textView.font =  UIFont.systemFont(ofSize: 15, weight: .regular)
        textView.textAlignment = .left
        textView.textColor = UIColor.text
        textView.text = text
        let moneyView = UILabel()
        moneyView.font =  UIFont.systemFont(ofSize: 15, weight: .regular)
        moneyView.textAlignment = .right
        moneyView.textColor = UIColor.text
        moneyView.text = ""
        let checkView = UIImageView()
        checkView.image = UIImage(named: "check_radio")
        view.addSubview(textView)
        view.addSubview(moneyView)
        view.addSubview(checkView)
        let height = 45
        view.snp.makeConstraints { (make) in
            make.height.equalTo(height)
            make.width.equalToSuperview()
            if topView != nil {
                make.top.equalTo(topView!.snp.bottom).offset(1)
            } else {
                make.top.equalToSuperview().offset(24)
            }
        }
        textView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.width.equalTo(100)
        }
        checkView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-8)
            make.width.equalTo(height - 10)
            make.height.equalTo(height - 10)
            make.centerY.equalToSuperview()
        }
        moneyView.snp.makeConstraints { (make) in
            make.right.equalTo(checkView.snp.left).offset(-8)
            make.width.equalTo(60)
            make.height.equalTo(height)
            make.centerY.equalToSuperview()
        }
//        checkView.tag = checks.count
        view.tag = views.count
        views.append(view)
        checks.append(checkView)
        moneys.append(moneyView)
        return view
    }
}
