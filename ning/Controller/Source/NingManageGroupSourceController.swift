//
//  ManageGroupSourceController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/15.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit
import DragAndDropTableView

class NingManageGroupSourceController: BaseListController {

    var items: SourceDir = SourceDir()
    var dirs: SourceDirList = SourceDirList()
    var listType: NingListType = .Topic
    var changed = false
    var deleteNum = 0
    
    convenience init(dirs: SourceDirList, items: SourceDir,listType: NingListType) {
        self.init()
        self.dirs = dirs
        self.items = items
        self.listType = listType
    }

    override func getNavLeftBarText() -> String {
        return TIP_CANCEL
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "管理订阅项"
        buildTopBarRightTextBtn(TIP_SUBMIT)
    }
    
    override func buildTableView() -> UITableView {
        let tableView = DragAndDropTableView(frame: .zero, style: .plain)
        tableView.backgroundColor = UIColor.background
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: ManageGroupSourceCell.self)
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
        GroupApiLoadingProvider.request(GroupApi.updateSourceOrder(type: type,did:items.id, order: items.idsString()),
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
    
    private func getDeleteTip() -> Bool {
        if listType == .Topic {
            if dirs.getAllSourceCount() - deleteNum <= 5 {
                showToast("请至少保留5个主题")
                return false
            }
        }
        return true
    }
}

extension NingManageGroupSourceController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ManageGroupSourceCell.self)
        cell.model = items[indexPath.row]
        cell.index = indexPath.row
        cell.removeImageView.isUserInteractionEnabled = true
        cell.removeImageView.tag = indexPath.row
        let gesture = UITapGestureRecognizer(target: self, action:#selector(tapRemoveSource))
        gesture.numberOfTapsRequired = 1
        cell.removeImageView.addGestureRecognizer(gesture)
        return cell
    }
    
    @objc private func tapRemoveSource(_ sender : UITapGestureRecognizer) {
        if !getDeleteTip() {
            return
        }
        let row = sender.view!.tag
        logInfo("tapRemoveSource row=\(row)")
        items.items.remove(at: row)
        self.tableView.reloadData()
        deleteNum += 1
        changed = true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
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

extension NingManageGroupSourceController : DragAndDropTableViewDataSource, DragAndDropTableViewDelegate {

    func tableView(_ tableView: DragAndDropTableView!, willBeginDraggingCellAt indexPath: IndexPath!, placeholderImageView placeHolderImageView: UIImageView!) {
        placeHolderImageView.layer.shadowOpacity = 0.3
        placeHolderImageView.layer.shadowRadius = 1
    }
    
    func tableView(_ tableView: DragAndDropTableView!, didEndDraggingCellAt sourceIndexPath: IndexPath!, to toIndexPath: IndexPath!, placeHolderView placeholderImageView: UIImageView!) {
        tableView.reloadData()
    }
    
}
