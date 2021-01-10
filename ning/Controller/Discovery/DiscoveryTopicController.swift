//
//  DiscoveryTopicController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/20.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class DiscoveryTopicController: DiscoverySourceController {

    override func reloadData() {
        var provider = TopicApiLoadingProvider
        if titles != nil && titles.count > 0 {
            provider = TopicApiProvider
        }
        provider.request(TopicApi.hotAll,
            model: HotTopicList.self) { [weak self] (returnData) in
             self?.handleResult(returnData)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if listType == .Topic {
            if hotTopicChanged {
                hotTopicChanged = false
                reloadData()
            }
        }
    }

    func handleResult(_ returnData: HotTopicList?) {
        if !showErrorResultToast(returnData) {
            return
        }
        setupNavi(returnData)
    }
    
    func setupNavi(_ returnData: HotTopicList?) {
        var titles = [String]()
        var controllers = [CatSourceListController]()
        for item in returnData!.items {
            titles.append(item.name)
            let items = SourceList(items: item.items)
            controllers.append(CatSourceListController(0, listType: listType, items:items))
        }
        self.titles = titles
        self.vcs = controllers
        self.pageStyle = .topTabBar
        setupLayout()
    }
    
}
