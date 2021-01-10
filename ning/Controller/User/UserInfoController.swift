//
//  UserInfoController.swift
//  ning
//
//

import UIKit
import ALCameraViewController

class UserInfoController: BaseViewController {
    
    private lazy var sectionArray: Array = {
        return [[["name":"profile", "title": "头像"]],
                
                [["name":"member", "title": "会员"]],
                
                [["name":"name", "title": "用户名"],
                 ["name":"email", "title": "邮箱"],["name":"pass", "title": "密码"]],
        [["name":"weixin", "title": "微信"],]]
    }()
    
    private lazy var sectionArray2: Array = {
        return [[["name":"profile", "title": "头像"]],
                [["name":"name", "title": "用户名"],
                 ["name":"email", "title": "邮箱"],["name":"pass", "title": "密码"]],
        [["name":"weixin", "title": "微信"],
        ["name":"weibo", "title": "微博"],["name":"qq", "title": "QQ"]]]
    }()
    
    

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = UIColor.background
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: UserProfileView.self)
        tableView.register(cellType: UserFieldView.self)
        return tableView
    }()
    
    override func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {(make) in
            make.edges.equalTo(self.view.usnp.edges).priority(.low)
            make.top.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "编辑信息"
        buildTopBarRightImageBtn("nav_logout")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    @objc override open func onClickTopBarRightBtn() {
        showConfirmAlert("确认要退出登录吗？",action: self.doLogout)
    }
    
    private func doLogout() {
        DAOFactory.unlogin()
        reloadApp()
        pressBack()
    }
    
    func handleProfile(image: UIImage) {
        if image.size.width < 200 || image.size.height < 200 {
            showAlert("头像需要大小至少是200*200")
        }
        var img = image
        logInfo("handleProfile image width=\(img.size.width) height=\(img.size.height)")
        if img.size.width > 300 {
            img = img.resizeWithWidth(300)
            img = img.resizeWithHeight(300)
        }
        logInfo("handleProfile image2 width=\(img.size.width) height=\(img.size.height)")
        guard let data = img.jpegData(compressionQuality: 1.0) else {
            showAlert("图片格式转换失败")
            return
        }
        UploadApiLoadingProvider.request(UploadApi.uploadProfile(data: data),
            model: UserWrapper.self) { [weak self] (returnData) in
            self?.postHandleProfile(returnData)
        }
    }
    
    private func postHandleProfile(_ result: UserWrapper?){
        if !showErrorResultAlert(result) {
            return
        }
        DAOFactory.getLoginUser()?.profile = result!.user!.profile
        DAOFactory.userDAO.saveUser(DAOFactory.getLoginUser()!)
        showToast("更新头像成功")
        tableView.reloadData()
    }
    
    private func clickWeixin() {
        guard let user = DAOFactory.getLoginUser() else {return}
        if user.weixin_name == nil || user.weixin_name!.isEmpty {
            clickBindWeixin()
        } else {
            if user.email != nil && !user.email!.isEmpty {
                clickCancelBindWeixin()
            }
        }
    }
    
    private func clickCancelBindWeixin() {
        showConfirmAlert("确定要取消关联微信吗？") {
            UserApiLoadingProvider.request(UserApi.cancelSocial(type: OAUTH_TYPE_WEIXIN),
                model: UserWrapper.self) { [weak self] (returnData) in
                self?.postBind(returnData)
            }
        }
    }
    
    private func clickBindWeixin() {
        if UIApplication.shared.canOpenURL(URL(string: "weixin://")!) == false {
            showToast("设备未安装微信")
            return
        }
        UMSocialManager.default().getUserInfo(with: UMSocialPlatformType.wechatSession, currentViewController: nil) { [weak self] (result, error) in
            if error == nil {
                let resp = result as! UMSocialUserInfoResponse
                self?.handleBindWeixin(resp)
            } else { // 授权失败
                logError(error)
                self?.showToast("调起微信授权失败")
            }
        }
    }
    
    private func handleBindWeixin(_ resp: UMSocialUserInfoResponse) {
        let oauth = OauthInfo()
        oauth.uid = resp.openid
        oauth.unionId = resp.unionId
        oauth.name = resp.name
        oauth.profile = resp.iconurl
        oauth.type = OAUTH_TYPE_WEIXIN
        oauth.token = resp.accessToken
        logInfo(oauth)
        UserApiLoadingProvider.request(UserApi.bindSocial(auth: oauth),
            model: UserWrapper.self) { [weak self] (returnData) in
            self?.postBind(returnData)
        }
    }
    
    func postBind(_ result: UserWrapper?){
        if !showErrorResultAlert(result) {
            return
        }
        let user = result!.user!
        DAOFactory.userDAO.saveUser(user)
        showToast(TIP_MODIFY_DONE)
        tableView.reloadData()
    }
}


extension UserInfoController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionArray[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = DAOFactory.getLoginUser()
        let item = sectionArray[indexPath.section][indexPath.row]
        let name = item["name"]!
        if name == "profile" {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UserProfileView.self)
            cell.setProfile(profile: user?.profile ?? "")
            return cell
        }
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UserFieldView.self)
        cell.setValue(name:item["title"]!, value:getUserFieldValue(user:user!,name:name))
        return cell
    }
    
    func getUserFieldValue(user: UserInfo, name: String) -> String {
        switch name {
        case "name":
            return user.name ?? ""
        case "weixin":
            if user.weixin_name == nil || user.weixin_name!.isEmpty {
                return "点击关联"
            }
            return user.weixin_name!
        case "email":
            return user.email ?? ""
        case "pass":
            if user.password != nil && !user.password!.isEmpty {
                return "修改密码"
            }
            return ""
        case "weibo":
            if user.weibo_name == nil || user.weibo_name!.isEmpty {
                return "点击关联"
            }
            return user.weibo_name!
        case "qq":
            if user.qq_name == nil || user.qq_name!.isEmpty {
                return "点击关联"
            }
            return user.qq_name!
        case "member":
            if user.is_member {
                if user.member_period == nil {
                    return "已是会员"
                }
                return "有效期到 \(user.member_period!)"
            }
            return "非会员"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = sectionArray[indexPath.section][indexPath.row]
        switch item["name"] {
        case "profile":
            let crop = CroppingParameters(isEnabled:true,
                                          allowResizing:true,
                                          allowMoving:true,minimumSize:CGSize(width: 200, height: 200))
            let cameraViewController = CameraViewController(croppingParameters:crop) { [weak self] image, asset in
                // Do something with your image here.
                self?.dismiss(animated: true, completion: nil)
                if image != nil {
                    self?.handleProfile(image: image!)
                }
            }
            present(cameraViewController, animated: true, completion: nil)
        case "name":
            pushViewController(UserNameController())
        case "pass":
            pushViewController(UserPasswordController())
        case "email":
            pushViewController(UserEmailController())
        case "member":
            pushViewController(MemberController())
        case "weixin":
            clickWeixin()
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 70
        }
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}
