//
//  ArticleDetailOpHandler.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/9.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class ArticleDetailOpHandler {

    let controller: NingArticleDetailController
    
    init(_ controller: NingArticleDetailController) {
        self.controller = controller
    }

    func clickRightBtnOption(_ name :String) {
        if name == "查看站点" {
            controller.pushViewController(NingSiteArticleListController(source:controller.articleWrapper!.site!,listType: .Site, isHot: false))
        } else if name == "查看原文" {
            controller.pushViewController(NingWebController(url: controller.article!.url))
        }
        if !DAOFactory.isLogin() {
            controller.showToast(TIP_LOGIN)
            return
        }
        if name == "收藏文章" {
            controller.pushViewController(FavArticleController(article: controller.article!))
        } else if name == "取消收藏" {
            cancelFav()
        } else if name == "添加待读" {
           doLate()
        } else if name == "取消待读" {
           cancelLate()
        }
    }
    
    private func cancelLate() {
        let article = controller.article!
        ArticleApiLoadingProvider.request(ArticleApi.cancelLate(id: article.id),
            model: BaseObject.self) { [weak self] (returnData) in
                self?.postCancelLateSubmit(returnData, article:article)
        }
    }
    
    private func postCancelLateSubmit(_ returnData: BaseObject?, article: Article) {
        if !controller.showErrorResultToast(returnData) {
            return
        }
        article.late = 0
        controller.showToast("已取消待读")
    }
    
    private func doLate() {
        let article = controller.article!
        ArticleApiLoadingProvider.request(ArticleApi.doLate(id: article.id),
            model: BaseObject.self) { [weak self] (returnData) in
                self?.postDoLateSubmit(returnData, article:article)
        }
    }
    
    private func postDoLateSubmit(_ returnData: BaseObject?, article: Article) {
        if !controller.showErrorResultToast(returnData) {
            return
        }
        article.late = 1
        controller.showToast("已添加待读")
    }
    
    private func cancelFav() {
        let article = controller.article!
        ArticleApiLoadingProvider.request(ArticleApi.unFav(id: article.id),
            model: Article.self) { [weak self] (returnData) in
                self?.postCancelFavSubmit(returnData, article:article)
        }
    }
    
    private func postCancelFavSubmit(_ returnData: Article?, article: Article) {
        if !controller.showErrorResultToast(returnData) {
            return
        }
        article.like = returnData!.like
        controller.showToast("已取消收藏")
    }
}
