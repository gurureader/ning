//
//  LoginController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/6.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class UserLoginController: BaseViewController {
    
    private lazy var loginView: LoginView = {
        return LoginView()
    }()

    override func setupLayout() {
        view.addSubview(loginView)
        loginView.snp.makeConstraints{ $0.edges.equalTo(self.view.usnp.edges) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "登录"
        loginView.submitView.addTarget(self, action: #selector(clickLoginEmail), for: .touchUpInside)
        loginView.weixinView.addTarget(self, action: #selector(clickLoginWeixin), for: .touchUpInside)
        buildTopBarRightImageBtn("nav_new_user")
    }
    
    @objc override func onClickTopBarRightBtn() {
        pushViewController(NewUserController())
    }

    @objc private func clickLoginEmail() {
        let email = NingUtils.trim(loginView.emailView.text)
        let password = NingUtils.trim(loginView.passwordView.text)
        if (email.isEmpty) {
            showAlert("邮箱不能为空")
            return
        }
        if (password.isEmpty) {
            showAlert("密码不能为空")
            return
        }
        UserApiLoadingProvider.request(UserApi.loginWithEmail(email: email, password: password),
            model: UserWrapper.self) { [weak self] (returnData) in
            self?.postLoginWithEmail(returnData)
        }
    }
    
    func postLoginWithEmail(_ result: UserWrapper?){
        if !showErrorResultAlert(result) {
            return
        }
        let user = result!.user!
        DAOFactory.userDAO.saveUser(user)
        if user.is_new {
            pushViewController(NingColdTopicController())
            return
        }
        reloadApp()
        pressBack()
    }
    
    @objc private func clickLoginWeixin() {
        logInfo("clickLoginWeixin")
        if UIApplication.shared.canOpenURL(URL(string: "weixin://")!) == false {
            showToast("设备未安装微信")
            return
        }
        UMSocialManager.default().getUserInfo(with: UMSocialPlatformType.wechatSession, currentViewController: nil) { [weak self] (result, error) in
            if error == nil {
                let resp = result as! UMSocialUserInfoResponse
                self?.handleLoginWeixin(resp)
            } else { // 授权失败
                logError(error)
                self?.showToast("调起微信授权失败")
            }
        }
    }
    
    private func handleLoginWeixin(_ resp: UMSocialUserInfoResponse) {
        let oauth = OauthInfo()
        oauth.uid = resp.openid
        oauth.unionId = resp.unionId
        oauth.name = resp.name
        oauth.profile = resp.iconurl
        oauth.type = OAUTH_TYPE_WEIXIN
        oauth.token = resp.accessToken
        logInfo(oauth)
        UserApiLoadingProvider.request(UserApi.loginWithSocial(auth: oauth),
            model: UserWrapper.self) { [weak self] (returnData) in
            self?.postLoginWithEmail(returnData)
        }
    }
}
