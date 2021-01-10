//
//  EditGroupController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/15.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class EditGroupController: BaseViewController {
    
    var listType: NingListType = .Topic
    var sourceDir: SourceDir?
    
    convenience init(sourceDir: SourceDir?, listType: NingListType) {
        self.init()
        self.listType = listType
        self.sourceDir = sourceDir
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
        self.title = "修改分组名"
        formView.nameView.text = sourceDir?.name
        buildTopBarRightTextBtn(TIP_SUBMIT)
    }

    override func onClickTopBarRightBtn() {
        let text = NingUtils.trim(formView.nameView.text)
        if text.isEmpty || text.count > 12 {
            showToast("名称长度无效")
            return
        }
        if text == sourceDir?.name {
            self.pressBack()
            return
        }
        let type = listType.groupTypeValue()
        GroupApiLoadingProvider.request(GroupApi.rename(type: type, id: sourceDir!.id, name: text),
            model: BaseObject.self) { [weak self] (returnData) in
                self?.postSubmit(returnData, name: text)
        }
    }
    
    func postSubmit(_ returnData: BaseObject?, name: String) {
        if !self.showErrorResultAlert(returnData) {
            return
        }
        subTabChanged(listType)
        sourceDir?.name = name
        self.showAlert("修改成功", action: {
            self.pressBack()
        })
    }
}
