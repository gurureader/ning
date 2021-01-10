//
//  SubTabController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/1.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class SubTabController: BasePageController {
    
    static func build() -> SubTabController {
        let titles = ["站点","主题","关键词"]
        let controllers = [SiteHomeController(),TopicHomeController(),KeywordListController()]
        return SubTabController(titles:titles, vcs:controllers,pageStyle: .navgationBarSegment)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildTopBarRightImageBtn("nav_more")
    }
    
    @objc override func onClickTopBarRightBtn() {
        var array = ["创建分组","排序分组","全部已读"]
        if currentSelectIndex == 2 {
            array = ["添加订阅","全部已读"]
        }
        _ = buildRightDropDown(array)
    }
    
}

extension SubTabController: RightDropDownOpration {

    func clickRightDropDownItem(item: String) {
        if !DAOFactory.isLogin() {
            self.showLoginToast()
            return
        }
        if item == "创建分组" {
            pushViewController(NingNewGroupController(listType: getCurrentListType()))
        } else if item == "全部已读" {
            markAllRead()
        } else if item == "排序分组" {
            let controller = getCurrentController() as! NingMyGroupSourceController
            let items = controller.items
            if items == nil || items!.count() < 3 {
                showToast("分组太少，不需要排序")
                return
            }
            pushViewController(ManageGroupController(items:items!.buildCustomDirs(), listType: getCurrentListType()))
        } else if item == "添加订阅" {
            let controller = NewKeywordController(source: nil)
            pushViewController(controller)
        }
    }
    
    private func markAllRead() {
        let listType = getCurrentListType()
        if listType == .Site {
            SiteApiLoadingProvider.request(SiteApi.markAllRead,
                model: BaseObject.self) { [weak self] (returnData) in
                self?.postMarkAllRead(returnData)
            }
        } else if listType == .Topic {
            TopicApiLoadingProvider.request(TopicApi.markAllRead,
                model: BaseObject.self) { [weak self] (returnData) in
                self?.postMarkAllRead(returnData)
            }
        } else if listType == .Keyword {
            KeywordApiLoadingProvider.request(KeywordApi.markAllRead,
                model: BaseObject.self) { [weak self] (returnData) in
                self?.postMarkAllRead(returnData)
            }
        }
    }
    
    private func postMarkAllRead(_ returnData: BaseObject?) {
        if !self.showErrorResultToast(returnData) {
            return
        }
        let listType = getCurrentListType()
        if (listType != .Keyword) {
            DAOFactory.getSourceCountDAO(listType).markAllRead()
            let controller = getCurrentController() as! NingMyGroupSourceController
            controller.markAllRead()
        } else {
            let controller = getCurrentController() as! KeywordListController
            controller.markAllRead()
        }
        showToast("已标记全部已读")
    }
}
