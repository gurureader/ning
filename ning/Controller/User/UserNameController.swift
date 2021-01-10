//
//  UserNameController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/14.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class UserNameController: BaseViewController {
    
    private lazy var formView: UserNameView = {
        return UserNameView()
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
        self.title = "修改名称"
        buildTopBarRightTextBtn(TIP_SUBMIT)
        formView.nameView.text = DAOFactory.getLoginUser()?.name
    }

    override func onClickTopBarRightBtn() {
        let text = NingUtils.trim(formView.nameView.text)
        if text.count < 2{
            showToast("名称长度无效")
            return
        }
        if text == DAOFactory.getLoginUser()?.name {
            pressBack()
            return
        }
        UserApiLoadingProvider.request(UserApi.updateName(name: text),
            model: UserWrapper.self) { [weak self] (returnData) in
            self?.postUpdateName(returnData)
        }
    }
    
    func postUpdateName(_ returnData: UserWrapper?) {
        if !self.showErrorResultAlert(returnData) {
            return
        }
        DAOFactory.getLoginUser()?.name = returnData!.user!.name
        DAOFactory.userDAO.saveUser(DAOFactory.getLoginUser()!)
        self.showAlert(TIP_MODIFY_DONE, action: {
            self.pressBack()
        })
    }

}
