//
//  TuikanArticleListController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/18.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class NingTuikanArticleListController: BasePageController {
    
    var kanList: Array<SourceModel> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的收藏"
        reloadData()
        buildTopBarRightImageBtn("nav_manage")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if pageDataRefreshed {
            pageDataRefreshed = false
            reloadData()
        }
    }
    
    @objc override func onClickTopBarRightBtn() {
        pushViewController(ManageTuikanController())
    }
    
    func reloadData() {
        ArticleApiLoadingProvider.request(ArticleApi.fav(kanId: 0, pn: 0),
            model: ArticleList.self) { [weak self] (returnData) in
            self?.callbackResult(returnData)
        }
    }

    open func callbackResult(_ returnData:ArticleList?) {
        if !showErrorResultToast(returnData) {
            return
        }
        returnData?.rebuild()
        kanList = returnData!.kans
        var titles = [String]()
        var controllers = [FavArticleListController]()
        titles.append("全部")
        controllers.append(FavArticleListController.build(catId: 0))
        for item in kanList {
            titles.append(item.name)
            controllers.append(FavArticleListController.build(catId: item.idInt()))
        }
        self.titles = titles
        self.vcs = controllers
        self.pageStyle = .topTabBar
        logInfo("callbackResult size=\(titles.count)")
        setupLayout()
    }
}
