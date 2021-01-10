//
//  NewUserController.swift
//  ning
//
//  Created by JianjiaYu on 2020/10/10.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class NewUserController: BaseViewController {
    
    private lazy var formView: NewUserFormView = {
        return NewUserFormView()
    }()

    override func setupLayout() {
        view.addSubview(formView)
        formView.snp.makeConstraints{ $0.edges.equalTo(self.view.usnp.edges) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "邮箱注册"
        formView.checkBtn.addTarget(self, action: #selector(clickCheckEmailCode), for: .touchUpInside)
        formView.submtBtn.addTarget(self, action: #selector(clickSubmit), for: .touchUpInside)
    }
    
    @objc private func clickCheckEmailCode() {
        let email = NingUtils.trim(formView.emailView.text)
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
    
    @objc private func clickSubmit() {
        let email = NingUtils.trim(formView.emailView.text)
        let name = NingUtils.trim(formView.nameView.text)
        let code = NingUtils.trim(formView.codeView.text)
        let pass = NingUtils.trim(formView.passView.text)
        let passAgain = NingUtils.trim(formView.againView.text)
        if (email.isEmpty) {
            showAlert("邮箱不能为空")
            return
        }
        if (name.isEmpty) {
            showAlert("用户名不能为空")
            return
        }
        if (code.isEmpty) {
            showAlert("验证码无效")
            return
        }
        if (pass.count < 8) {
            showAlert("密码长度无效")
            return
        }
        if (pass != passAgain) {
            showAlert("两次密码不一致")
            return
        }
        SignupApiLoadingProvider.request(SignupApi.registerByEmail(email: email, name: name, code: code, password: pass),
            model: UserWrapper.self) { [weak self] (returnData) in
            self?.postSubmit(returnData)
        }
    }

    func postSubmit(_ result: UserWrapper?){
        if !showErrorResultAlert(result) {
            return
        }
        let user = result!.user!
        DAOFactory.userDAO.saveUser(user)
        pushViewController(NingColdTopicController())
    }
}
