//
//  TopicArticleListController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/8.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class NingTopicArticleListController: SourceArticleListController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override open func requestData(_ pn: Int,_ refresh: Bool = false) {
        TopicApiProvider.request(TopicApi.show(id: Int(source!.id) ?? 0, lang:1, pn: pn),
            model: ArticleList.self) { [weak self] (returnData) in
            self?.callbackResult(returnData,pn:pn)
        }
    }

}
