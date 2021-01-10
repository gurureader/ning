//
//  UserPasswordController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/14.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class UserPasswordController: BaseViewController {
    
    private lazy var formView: UserPasswordView = {
        return UserPasswordView()
    }()

    override func setupLayout() {
        view.addSubview(formView)
        formView.snp.makeConstraints{ $0.edges.equalTo(self.view.usnp.edges) }
    }
    
    override func getNavLeftBarText() -> String {
        return TIP_CANCEL
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "修改密码"
        buildTopBarRightTextBtn(TIP_SUBMIT)
    }

    override func onClickTopBarRightBtn() {
        let oldPass = NingUtils.trim(formView.oldView.text)
        let newPass = NingUtils.trim(formView.newView.text)
        let againPass = NingUtils.trim(formView.againView.text)
        if  newPass.count < 8 {
            showToast("密码长度无效")
            return
        }
        if newPass != againPass {
            showToast("两次密码不一致")
            return
        }
        UserApiLoadingProvider.request(UserApi.updatePassword(newPassword: newPass, old: oldPass),
            model: BaseObject.self) { [weak self] (returnData) in
            self?.postSubmit(returnData, pass: newPass)
        }
    }
    
    func postSubmit(_ returnData: BaseObject?, pass: String) {
        if !self.showErrorResultAlert(returnData) {
            return
        }
        DAOFactory.getLoginUser()?.password = pass
        DAOFactory.userDAO.saveUser(DAOFactory.getLoginUser()!)
        self.showAlert(TIP_MODIFY_DONE, action: {
            self.pressBack()
        })
    }

}
