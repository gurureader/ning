//
//  SiteArticleListController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/8.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class NingSiteArticleListController: SourceArticleListController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override open func requestData(_ pn: Int,_ refresh: Bool = false) {
        SiteApiProvider.request(SiteApi.show(id: source!.id, pn: pn),
            model: ArticleList.self) { [weak self] (returnData) in
            self?.callbackResult(returnData,pn:pn)
        }
    }

}
