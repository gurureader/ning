//
//  FavArticleListController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/7.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class FavArticleListController: NingArticleListController {
    
    static func build(catId: Int = 0) -> FavArticleListController {
        return FavArticleListController(catId, listType: .Fav)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的收藏"
    }
    
    override func requestData(_ pn: Int,_ refresh: Bool = false) {
        var provider = ArticleApiLoadingProvider
        if items.count() > 0 || refresh{
            provider = ArticleApiProvider
        }
        provider.request(ArticleApi.fav(kanId: catId, pn: pn),
            model: ArticleList.self) { [weak self] (returnData) in
            self?.callbackResult(returnData,pn:pn)
        }
    }
}
