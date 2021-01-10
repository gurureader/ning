//
//  UserNameController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/14.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class UserEmailController: BaseViewController {
    
    private lazy var formView: UserEmailView = {
        return UserEmailView()
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
        let user = DAOFactory.getLoginUser()
        if user?.email == nil || user!.email!.isEmpty {
            self.title = "关联邮箱"
        } else {
            self.title = "修改邮箱"
        }
        buildTopBarRightTextBtn(TIP_SUBMIT)
        formView.checkBtn.addTarget(self, action: #selector(clickCheckEmailCode), for: .touchUpInside)
    }
    
    @objc private func clickCheckEmailCode() {
        let email = NingUtils.trim(formView.nameView.text)
        if (email.isEmpty) {
            showAlert("邮箱不能为空")
            return
        }
        formView.checkBtn.isEnabled = false
        SignupApiLoadingProvider.request(SignupApi.check_email_code(email: email),
            model: BaseObject.self) { [weak self] (returnData) in
            self?.postCheckEmailCode(returnData)
        }
    }
    
    func postCheckEmailCode(_ result: BaseObject?){
        if !showErrorResultAlert(result) {
            formView.checkBtn.isEnabled = true
            return
        }
        formView.checkBtn.isEnabled = false
        formView.checkBtn.setTitleColor(UIColor.lightGray, for: .normal)
        showAlert("已向邮箱发送验证码，请查收")
    }

    override func onClickTopBarRightBtn() {
        let text = NingUtils.trim(formView.nameView.text)
        let code = NingUtils.trim(formView.codeView.text)
        if text.count < 5{
            showToast("邮箱地址无效")
            return
        }
        if (code.isEmpty) {
            showAlert("验证码无效")
            return
        }
        if text == DAOFactory.getLoginUser()?.email {
            pressBack()
            return
        }
        UserApiLoadingProvider.request(UserApi.updateEmail(email: text, code: code),
            model: UserWrapper.self) { [weak self] (returnData) in
            self?.postUpdateName(returnData)
        }
    }
    
    func postUpdateName(_ returnData: UserWrapper?) {
        if !self.showErrorResultAlert(returnData) {
            return
        }
        DAOFactory.getLoginUser()?.email = returnData!.user!.email
        DAOFactory.userDAO.saveUser(DAOFactory.getLoginUser()!)
        self.showAlert(TIP_MODIFY_DONE, action: {
            self.pressBack()
        })
    }

}
