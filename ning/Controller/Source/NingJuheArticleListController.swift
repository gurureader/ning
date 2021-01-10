//
//  JuheArticleListController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/13.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class NingJuheArticleListController: SourceArticleListController {
    
    var sourceDir: SourceDir?
    var sourceDirList: SourceDirList?

    override func viewDidLoad() {
        super.viewDidLoad()
        if DAOFactory.isLogin() {
            buildTopBarRightImageBtn("nav_more")
        }
    }
    
    convenience init(sourceDirList: SourceDirList, sourceDir: SourceDir,listType: NingListType) {
        self.init()
        self.sourceDirList = sourceDirList
        self.sourceDir = sourceDir
        self.listType = listType
        self.source = SourceModel()
        self.source?.name = sourceDir.name
        self.source?.id = String(sourceDir.id)
        self.source?.image = "juhe"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @objc override func onClickTopBarRightBtn() {
        if sourceDir?.name == "默认分组" {
            _ = buildRightDropDown(["管理订阅项","迁移订阅项","全部已读"])
        } else {
            _ = buildRightDropDown(["修改分组名","管理订阅项","迁移订阅项","删除分组","全部已读"])
        }
    }

    override open func requestData(_ pn: Int,_ refresh: Bool = false ) {
        let code = items.code ?? ""
        if listType == .Site {
            SiteApiProvider.request(SiteApi.juheReading(id: source!.id, pn: pn, code: code),
                model: ArticleList.self) { [weak self] (returnData) in
                self?.callbackResult(returnData,pn:pn)
            }
        } else {
            TopicApiProvider.request(TopicApi.juheReading(id: source!.id, pn: pn, code: code),
                model: ArticleList.self) { [weak self] (returnData) in
                self?.callbackResult(returnData,pn:pn)
            }
        }
    }

}

extension NingJuheArticleListController: RightDropDownOpration {
    
    func clickRightDropDownItem(item: String) {
        if !DAOFactory.isLogin() {
            self.showLoginToast()
            return
        }
        switch item {
        case "修改分组名":
            clickEditGroupName(sourceDir!)
        case "管理订阅项":
            clickManageGroup(sourceDir!)
        case "迁移订阅项":
            clickTransferGroup(sourceDir!)
        case "删除分组":
            clickDeleteGroup(sourceDir!)
        case "全部已读":
            markAllRead(sourceDir!)
        default:
            break
        }
    }
    
    private func clickEditGroupName(_ sourceDir: SourceDir) {
        pushViewController(EditGroupController(sourceDir: sourceDir, listType: listType))
    }
    
    private func clickDeleteGroup(_ sourceDir: SourceDir) {
        if listType == .Topic {
            let left = sourceDirList!.getAllSourceCount() - sourceDir.count()
            if left < 5 {
                showToast("订阅的主题数不能少于5个")
                return
            }
        }
        let tip = "确定要删除分组《\(sourceDir.name)》及其中的订阅项吗？"
        showConfirmAlert(tip) {
            self.doClickDeleteGroup(sourceDir)
        }
    }
    
    private func doClickDeleteGroup(_ sourceDir: SourceDir) {
        let type = listType.groupTypeValue()
        logInfo("clickDeleteGroup type=\(type) id=\(sourceDir.id)")
        GroupApiLoadingProvider.request(GroupApi.removeGroup(type: type, id: sourceDir.id),
            model: BaseObject.self) { [weak self] (returnData) in
            self?.postDeleteGroup(returnData)
        }
    }
    
    func postDeleteGroup(_ returnData: BaseObject?) {
        if !self.showErrorResultAlert(returnData) {
            return
        }
        subTabChanged(listType)
        self.showAlert("删除成功", action: {
            self.pressBack()
        })
    }
    
    private func markAllRead(_ sourceDir: SourceDir) {
        if listType == .Site {
            SiteApiLoadingProvider.request(SiteApi.markGroupRead(id: sourceDir.id),
                model: BaseObject.self) { [weak self] (returnData) in
                self?.postMarkAllRead(returnData)
            }
        } else {
            TopicApiLoadingProvider.request(TopicApi.markGroupRead(id: sourceDir.id),
                model: BaseObject.self) { [weak self] (returnData) in
                self?.postMarkAllRead(returnData)
            }
        }
    }
    
    private func postMarkAllRead(_ returnData: BaseObject?) {
        if !self.showErrorResultToast(returnData) {
            return
        }
        DAOFactory.getSourceCountDAO(listType).markDirRead(sourceDir: sourceDir!)
//        subTabChanged(listType)
        showToast("已标记全部已读")
    }
    
    private func clickTransferGroup(_ sourceDir: SourceDir) {
        if sourceDirList!.count() < 2 {
            showToast("没有足够的分组")
            return
        }
        pushViewController(TransferGroupController(sourceDir: sourceDir, items: sourceDirList!,listType: listType))
    }
    
    private func clickManageGroup(_ sourceDir: SourceDir) {
        if sourceDir.count() == 0 {
            showToast("该分组订阅项为空")
            return
        }
        pushViewController(NingManageGroupSourceController(dirs: sourceDirList!, items: sourceDir.copy(), listType: listType))
    }
    
}
