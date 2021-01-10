//
//  NewGroupController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/14.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class NingNewGroupController: BaseViewController {
    
    var listType: NingListType = .Topic
    
    convenience init(listType: NingListType) {
        self.init()
        self.listType = listType
    }
    
    private lazy var formView: NingNewGroupView = {
        return NingNewGroupView()
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
        self.title = "创建分组"
        buildTopBarRightTextBtn(TIP_SUBMIT)
    }

    override func onClickTopBarRightBtn() {
        let text = NingUtils.trim(formView.nameView.text)
        if text.isEmpty || text.count > 12 {
            showToast("名称长度无效")
            return
        }
        let type = listType.groupTypeValue()
        GroupApiLoadingProvider.request(GroupApi.addGroup(type: type, name: text),
            model: BaseObject.self) { [weak self] (returnData) in
            self?.postSubmit(returnData)
        }
    }
    
    func postSubmit(_ returnData: BaseObject?) {
        if !self.showErrorResultAlert(returnData) {
            return
        }
        subTabChanged(listType)
        self.showAlert("添加成功", action: {
            self.pressBack()
        })
    }
}
