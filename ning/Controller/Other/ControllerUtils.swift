//
//  ControllerUtils.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/21.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class ControllerUtils {

    var controller: BaseViewController
    var isHot = false
    
    init(controller: BaseViewController,isHot:Bool) {
        self.controller = controller
        self.isHot = isHot
    }

    func followSource(listType: NingListType, item: SourceModel?, table: UITableView?, header: SourceArticleHeader?) {
        if !DAOFactory.isLogin() {
            controller.showLoginToast()
            return
        }
        if item == nil {
            return
        }
        let source = item!
        if source.followed {
            if listType == .Topic {
                TopicApiLoadingProvider.request(TopicApi.unfollow(id: source.id),
                    model: BaseObject.self) { [weak self] (returnData) in
                        self?.postFollowSource(returnData, source:source, followed:false, table:table, header:header,listType:listType)
                }
            } else {
                SiteApiLoadingProvider.request(SiteApi.unfollow(id: source.id),
                    model: BaseObject.self) { [weak self] (returnData) in
                        self?.postFollowSource(returnData, source:source, followed:false, table:table, header:header,listType:listType)
                }
            }
        } else {
            if listType == .Topic {
                TopicApiLoadingProvider.request(TopicApi.follow(id: source.id),
                    model: BaseObject.self) { [weak self] (returnData) in
                        self?.postFollowSource(returnData, source:source, followed:true, table:table, header:header,listType:listType)
                }
            } else {
                SiteApiLoadingProvider.request(SiteApi.follow(id: source.id),
                    model: BaseObject.self) { [weak self] (returnData) in
                        self?.postFollowSource(returnData, source:source, followed:true, table:table, header:header, listType:listType)
                }
            }
        }
    }

    private func postFollowSource(_ returnData: BaseObject?, source: SourceModel, followed: Bool,table: UITableView?, header: SourceArticleHeader?, listType: NingListType) {
        if !controller.showErrorResultToast(returnData) {
            return
        }
        source.followed = followed
        if listType == .Topic {
            subTopicChanged = true
        } else if listType == .Site {
            subSiteChanged = true
        }
        if table != nil {
            table?.reloadData()
        } else {
            header?.model = source
            if !isHot {
                if listType == .Topic {
                    hotTopicChanged = true
                } else if listType == .Site {
                    hotSiteChanged = true
                }
            }
        }
    }

}
