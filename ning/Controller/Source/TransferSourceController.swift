//
//  TransferSourceController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/16.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class TransferSourceController: BaseListController {

    var source: SourceModel = SourceModel()
    var items: SourceDirList = SourceDirList()
    var listType: NingListType = .Topic
    
    convenience init(source: SourceModel, items: SourceDirList,listType: NingListType) {
        self.init()
        self.source = source
        for item in items.items {
            if item.id != source.did {
                self.items.append(item)
            }
        }
        self.listType = listType
    }
    
    override func getNavLeftBarText() -> String {
        return TIP_CANCEL
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "迁移到分组"
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
        let type = listType.groupTypeValue()
        GroupApiLoadingProvider.request(GroupApi.moveItem(type: type, itemId: source.id, groupId: item!.id),
            model: BaseObject.self) { [weak self] (returnData) in
                self?.postSubmit(returnData)
        }
    }
    
    func postSubmit(_ returnData: BaseObject?) {
        if !self.showErrorResultAlert(returnData) {
            return
        }
        subTabChanged(listType)
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


extension TransferSourceController : UITableViewDelegate, UITableViewDataSource {
    
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
