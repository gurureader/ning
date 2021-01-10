//
//  DiscoverySiteController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/20.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class DiscoverySiteController: DiscoverySourceController {
    
    override var listType: NingListType {
        get {
            return .Site
        }
        set {
            
        }
    }

    override func reloadData() {
        var provider = SiteApiLoadingProvider
        if titles != nil && titles.count > 0 {
            provider = SiteApiProvider
        }
        provider.request(SiteApi.hot(cid: 0),
            model: HotSiteList.self) { [weak self] (returnData) in
             self?.handleResult(returnData)
        }
    }

    func handleResult(_ returnData: HotSiteList?) {
        if !showErrorResultToast(returnData) {
            return
        }
        navi = returnData!.navi
        let items = SourceList(items:returnData!.items)
        setupNavi(items)
    }
    
    func setupNavi(_ items: SourceList?) {
        var titles = [String]()
        var controllers = [CatSourceListController]()
        var index = 0
        for item in navi {
            titles.append(item.name)
            if index == 0 &&  items != nil {
                controllers.append(CatSourceListController(item.idInt(), listType: listType, items:items!))
            } else {
                controllers.append(CatSourceListController(item.idInt(), listType: listType, items:SourceList()))
            }
            index += 1
        }
        self.titles = titles
        self.vcs = controllers
        self.pageStyle = .topTabBar
        setupLayout()
    }
}
