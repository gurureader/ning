//
//  EditTuikanController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/17.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class EditTuikanController: BaseViewController {
    
    var source: SourceModel?
    
    convenience init(source: SourceModel?) {
        self.init()
        self.source = source
    }
    
    private lazy var formView: NewTuikanView = {
        return NewTuikanView()
    }()

    override func setupLayout() {
        view.addSubview(formView)
        formView.snp.makeConstraints{ $0.edges.equalTo(self.view.usnp.edges) }
        formView.model = source
    }
    
    override func getNavLeftBarText() -> String {
        return TIP_CANCEL
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if source == nil {
            self.title = "创建收藏夹"
        } else {
            self.title = "修改收藏夹"
        }
        buildTopBarRightTextBtn(TIP_SUBMIT)
    }

    override func onClickTopBarRightBtn() {
        let text = NingUtils.trim(formView.nameView.text)
        if text.count < 2 {
            showToast("名称长度无效")
            return
        }
        var type = 1
        if formView.privateState {
            type = 0
        }
        if source != nil && text == source?.name && type == source?.type{
            pressBack()
            return
        }
        if source == nil {
            TuikanApiLoadingProvider.request(TuikanApi.create(name: text, type: type),
                model: BaseObject.self) { [weak self] (returnData) in
                self?.postSubmit(returnData)
            }
        } else {
            guard let id = Int(source!.id) else {
                return
            }
            TuikanApiLoadingProvider.request(TuikanApi.update(id:id, name: text, type: type),
                model: BaseObject.self) { [weak self] (returnData) in
                self?.postSubmit(returnData)
            }
        }
    }
    
    func postSubmit(_ returnData: BaseObject?) {
        if !self.showErrorResultAlert(returnData) {
            return
        }
        pageDataRefreshed = true
        pressBack()
    }
}
