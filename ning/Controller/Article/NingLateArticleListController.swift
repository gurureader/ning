//
//  LateArticleListController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/7.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class NingLateArticleListController: NingArticleListController {

    static func build() -> NingLateArticleListController {
        return NingLateArticleListController(listType: .Late)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的待读"
    }
    
    override open func requestData(_ pn: Int,_ refresh: Bool = false) {
        ArticleApiProvider.request(ArticleApi.late(pn: pn),
            model: ArticleList.self) { [weak self] (returnData) in
            self?.callbackResult(returnData,pn:pn)
        }
    }
}
