//
//  MemberController.swift
//  ning
//
//  Created by tuicool on 2020/11/11.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit
import SwiftyStoreKit

class MemberController: BaseViewController {

    var member: MemberInfo?
    var payType = 0
    var transaction: PaymentTransaction?
    
    lazy var memberView: MemberView = {
        return MemberView()
    }()
    
    override func setupLayout() {
        view.addSubview(memberView)
        memberView.snp.makeConstraints{ $0.edges.equalTo(self.view.usnp.edges) }
        memberView.submitBtn.addTarget(self, action: #selector(clickSubmit), for: .touchUpInside)
//        let scrollPoint = CGPoint(x: 0, y: memberView.webView.scrollView.contentSize.height - memberView.webView.frame.size.height)
//        memberView.webView.scrollView.setContentOffset(scrollPoint, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if DAOFactory.getLoginUser()!.is_member {
            self.title = "续费会员"
        } else {
            self.title = "开通会员"
        }
        memberView.isHidden = true
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func loadData() {
        UserApiLoadingProvider.request(UserApi.memberInfo,
            model: MemberInfo.self) { [weak self] (returnData) in
            self?.callbackResult(returnData)
        }
    }
    
    open func callbackResult(_ returnData:MemberInfo?) {
        if !showErrorResultToast(returnData) {
            return
        }
        member = returnData
        memberView.model = member
        memberView.isHidden = false
    }
    
    @objc func clickSubmit() {
        showToast("开源版本仅供学习，支付相关功能被删除")
    }
    
    
}
