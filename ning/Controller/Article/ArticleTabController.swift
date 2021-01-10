//
//  ArticleTabController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/1.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit
import LSDialogViewController

class ArticleTabController: BasePageController {
    
    static func build() -> ArticleTabController {
        var titles = ["热门","科技","创投","数码","技术","设计","营销","商业","区块链","第九区"]
        if DAOFactory.isLogin() {
            titles.insert("推荐", at: 0)
        }
        var controllers = [BaseViewController]()
        for title in titles {
            controllers.append(NingArticleListController(getCatId(title: title)))
        }
        return ArticleTabController(titles:titles, vcs:controllers,pageStyle: .topTabBar)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildTopBarRightImageBtn("nav_search")
    }
    
    @objc override func onClickTopBarRightBtn() {
        let controller = NingSearchController.build()
        pushViewController(controller)
    }
    
    
    static func getCatId(title:String) -> Int{
        switch title {
        case "推荐":
            return 1
        case "热门":
            return 0
        case "科技":
            return 101000000
        case "创投":
            return 101040000
        case "数码":
            return 101050000
        case "技术":
            return 20
        case "设计":
            return 108000000
        case "营销":
            return 114000000
        case "区块链":
            return 122000000
        case "商业":
            return 4
        case "第九区":
            return 122000001
        default:
            return 0
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkAgreement()
    }
}


extension ArticleTabController {
    
    func checkAgreement() {
        if PreferenceManager.isShowAgreement() {
            return
        }
        showAgreement()
    }
    
    func showAgreement() {
        let controller = AgreementDialog()
        self.presentDialogViewController(controller, animationPattern: .fadeInOut, completion: { () -> Void in })
        NotificationCenter.default.addObserver(self,selector: #selector(self.closeAgreementView),name:NSNotification.Name("closeAgreementView"),object: nil)
    }
    
    @objc func closeAgreementView() {
        self.dismissDialogViewController(.fadeInOut)
    }
}

