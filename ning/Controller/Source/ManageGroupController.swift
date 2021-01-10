//
//  ManageGroupController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/15.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit
import DragAndDropTableView

class ManageGroupController: BaseListController {

    var items: SourceDirList = SourceDirList()
    var listType: NingListType = .Topic
    var changed = false
    
    convenience init(items: SourceDirList,listType: NingListType) {
        self.init()
        self.items = items
        self.listType = listType
    }

    override func getNavLeftBarText() -> String {
        return TIP_CANCEL
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "排序分组"
        buildTopBarRightTextBtn(TIP_SUBMIT)
    }
    
    override func buildTableView() -> UITableView {
        let tableView = DragAndDropTableView(frame: .zero, style: .plain)
        tableView.backgroundColor = UIColor.background
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: NingManageGroupCell.self)
        return tableView
    }
    
    override func requestData(_ pn: Int,_ refresh: Bool = false) {
        tableView.reloadData()
    }
    
    override func onClickTopBarRightBtn() {
        if !changed {
            pressBack()
            return
        }
        let type = listType.groupTypeValue()
        GroupApiLoadingProvider.request(GroupApi.updateGroupOrder(type: type, order: items.idsString()),
            model: BaseObject.self) { [weak self] (returnData) in
                self?.postSubmit(returnData)
        }
    }
    
    func postSubmit(_ returnData: BaseObject?) {
        if !self.showErrorResultAlert(returnData) {
            return
        }
        subTabChanged(listType)
        self.showAlert("修改成功", action: {
            self.pressBack()
        })
    }
}

extension ManageGroupController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: NingManageGroupCell.self)
        cell.model = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        logInfo("moveRowAt \(sourceIndexPath.row) to \(destinationIndexPath.row)")
        let item = items[sourceIndexPath.row]
        items.items.remove(at: sourceIndexPath.row)
        items.items.insert(item!, at: destinationIndexPath.row)
        changed = true
    }
    
}

extension ManageGroupController : DragAndDropTableViewDataSource, DragAndDropTableViewDelegate {

    func tableView(_ tableView: DragAndDropTableView!, willBeginDraggingCellAt indexPath: IndexPath!, placeholderImageView placeHolderImageView: UIImageView!) {
        placeHolderImageView.layer.shadowOpacity = 0.3
        placeHolderImageView.layer.shadowRadius = 1
    }
    
    func tableView(_ tableView: DragAndDropTableView!, didEndDraggingCellAt sourceIndexPath: IndexPath!, to toIndexPath: IndexPath!, placeHolderView placeholderImageView: UIImageView!) {
        tableView.reloadData()
    }
    
}
