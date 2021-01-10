//
//  MyGroupSourceController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/9.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class NingMyGroupSourceController: BaseListController {

    var currentGroupHeaderCell: NingGroupHeaderCell?
    var currentGroupItemCell: NingGroupItemCell?
    var items: SourceDirList?

    override func buildTableView() -> UITableView {
        let tableView = super.buildTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 0.1))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 0.1))
        tableView.register(cellType: NingGroupItemCell.self)
        tableView.register(NingGroupHeaderCell.self, forHeaderFooterViewReuseIdentifier: "HeaderView")
        return tableView
    }
    
    override func getTableStyle() -> UITableView.Style {
        return .grouped
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func markAllRead() {
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if getSourceListType() == .Site && subSiteChanged {
            subSiteChanged = false
            refreshTable()
        } else if getSourceListType() == .Topic && subTopicChanged {
            subTopicChanged = false
            refreshTable()
        } else {
            if items != nil && items!.count() > 0 {
                tableView.reloadData()
            }
        }
    }
    
    
    func getSource(indexPath: IndexPath) -> SourceModel? {
        return items?[indexPath.section]?[indexPath.row]
    }
    
    open func callbackResult(_ returnData:SourceDirList?) {
        self.tableView.uHead.endRefreshing()
        self.tableView.uFoot.endRefreshing()
        if !showErrorResultToast(returnData) {
            if self.items == nil || self.items?.count() == 0 {
                self.tableView.uempty?.allowShow = true
                logInfo("show empty tableview")
            }
            return
        }
        self.items = returnData
        if self.items!.count() > 0 {
            for item in self.items!.items {
                item.expend = false
            }
            self.items![self.items!.count()-1]?.expend = true
        }
        self.items?.rebuild()
        checkUnreadCounts(returnData!)
        self.tableView.reloadData()
    }
    
    func checkUnreadCounts(_ sourceDirs: SourceDirList) {
        let dao = DAOFactory.getSourceCountDAO(getSourceListType())
        for sourceDir in sourceDirs.items {
            for source in sourceDir.items {
                let sourceCount = dao.getSourceCount(source.id)
                if sourceCount == nil {
                    dao.save(item: SourceCount(source: source))
                } else if sourceCount?.cnt != source.cnt {
                    sourceCount!.cnt = source.cnt
                    if source.time != nil {
                        sourceCount!.lastTime = source.time!
                    }
                    dao.update(item: sourceCount!)
                }
            }
        }
    }
    
    func showSourceDetailController(_ source: SourceModel) {
        if getSourceListType() == .Site {
            pushViewController(NingSiteArticleListController(source:source,listType: .Site,isHot: false))
        } else {
            pushViewController(NingTopicArticleListController(source:source,listType: .Topic,isHot: false))
        }
    }
    
    open func getSourceListType() -> NingListType {
        return .Topic
    }
    
    @objc private func itemLongPress(_ sender : UILongPressGestureRecognizer) {
        logInfo("itemLongPress state=\(sender.state.rawValue)")
        if sender.state != .began {
            return
        }
        let cell = sender.view as! NingGroupItemCell
        cell.becomeFirstResponder()
        currentGroupItemCell = cell
        showListAlert("执行操作", items:["迁移到分组","取消"])
//        showListAlert("选择操作", items:["迁移到分组"])
//        let menuController = UIMenuController.shared
//        let item1 = UIMenuItem(title: "迁移到分组", action: #selector(transferSource))
//        let item2 = UIMenuItem(title: "取消订阅", action: #selector(unfollowSource))
//        menuController.menuItems = [item1, item2]
//        menuController.setTargetRect(cell.frame, in: tableView)
//        menuController.setMenuVisible(true, animated: true)
    }
    
    override func clickListAlertValue(value: String) {
        if value == "迁移到分组" {
            transferSource() 
        } else if value == "取消订阅" {
            
        }
    }
    
    private func transferSource() {
        guard let model = currentGroupItemCell?.model else {
            return
        }
        let controller = TransferSourceController(source: model, items: items!, listType: getSourceListType())
        pushViewController(controller)
    }
    
    @objc private func unfollowSource() {
        
    }
    
}

extension NingMyGroupSourceController: GroupHeaderCellDelegate {
    
    func tapGroupHeaderCell(view: NingGroupHeaderCell) {
        let model = view.model
        model!.expend = !model!.expend
        tableView.reloadSections(IndexSet.init(integer: view.tag), with: .fade)
    }
    
    func tapGroupHeaderJuhe(view: NingGroupHeaderCell) {
        let controller = NingJuheArticleListController(sourceDirList: items!, sourceDir: view.model!,listType: getSourceListType())
        pushViewController(controller)
    }
}


extension NingMyGroupSourceController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let source = getSource(indexPath: indexPath)
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: NingGroupItemCell.self)
        if DAOFactory.isLogin() {
            let dao = DAOFactory.getSourceCountDAO(getSourceListType())
            source?.cnt = dao.getUnreadCount(source!.id)
        } else {
            source?.cnt = 0
        }
        cell.model = source
        if DAOFactory.isLogin() {
            let gesture = UILongPressGestureRecognizer(target: self, action:#selector(itemLongPress))
            cell.addGestureRecognizer(gesture)
        }
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let source = getSource(indexPath: indexPath)
        showSourceDetailController(source!)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sourceDir = items![section]
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView") as! NingGroupHeaderCell
        cell.model = sourceDir
        cell.tag = section
        cell.delegate = self
        cell.contentView.backgroundColor = UIColor.background
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cnt = items?[section]?.count() ?? 0
        if (cnt > 0) {
            if items![section]!.expend {
                return cnt
            }
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let cnt = items?.count() ?? 0
        return cnt
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}


