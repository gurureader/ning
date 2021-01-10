//
//  TransferGroupController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/16.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class TransferGroupController: BaseListController {

    var sourceDir: SourceDir = SourceDir()
    var items: SourceDirList = SourceDirList()
    var listType: NingListType = .Topic
    
    convenience init(sourceDir: SourceDir, items: SourceDirList,listType: NingListType) {
        self.init()
        self.sourceDir = sourceDir
        for item in items.items {
            if item.id != sourceDir.id {
                self.items.items.append(item)
            }
        }
        self.listType = listType
    }
    
    override func getNavLeftBarText() -> String {
        return TIP_CANCEL
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "迁移订阅项"
        buildTopBarRightTextBtn(TIP_SUBMIT)
    }
    
    override func buildTableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = UIColor.background
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: NingGroupCangCell.self)
        return tableView
    }
    
    override func requestData(_ pn: Int,_ refresh: Bool = false) {
        tableView.reloadData()
    }
    
    override func onClickTopBarRightBtn() {
        let item = getCheckedItem()
        if item == nil {
            showToast("请选择订阅项迁移后的分组")
            return
        }
        var tip = "确定要迁移分组《\(sourceDir.name)》下的订阅项到分组《\(item!.name)》并删除该分组吗？"
        if sourceDir.id == 0 {
            tip = "确定要迁移默认分组下的订阅项到分组《\(item!.name)》吗？"
        }
        showAlert(tip) {
            
        }
    }
    
    private func doSubmit(_ item: SourceDir) {
        let type = listType.groupTypeValue()
        GroupApiLoadingProvider.request(GroupApi.transferItems(type: type, fromGroupId: sourceDir.id, toGroupId: item.id),
            model: BaseObject.self) { [weak self] (returnData) in
                self?.postSubmit(returnData)
        }
    }
    
    func postSubmit(_ returnData: BaseObject?) {
        if !self.showErrorResultAlert(returnData) {
            return
        }
        subTabChanged(listType)
        pageClosed = true
        self.showAlert("迁移成功", action: {
            self.pressBack()
        })
    }
    
    private func getCheckedItem() -> SourceDir? {
        for item in items.items {
            if item.checked {
                return item
            }
        }
        return nil
    }
}


extension TransferGroupController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: NingGroupCangCell.self)
        cell.model = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        clearCheckStates()
        let model = items[indexPath.row]
        model?.checked = true
        self.tableView.reloadData()
    }
    
    private func clearCheckStates() {
        for item in items.items {
            item.checked = false
        }
    }
}
