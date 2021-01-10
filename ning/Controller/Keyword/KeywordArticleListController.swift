//
//  FavArticleListController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/7.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class KeywordArticleListController: NingArticleListController {
    
    var source = SourceModel()
    
    static func build(source: SourceModel) -> KeywordArticleListController {
        return KeywordArticleListController(source)
    }
    
    convenience init(_ source: SourceModel) {
        self.init()
        self.source = source
        self.listType = .Keyword
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = source.name
        buildTopBarRightImageBtn("nav_more")
    }

    @objc override func onClickTopBarRightBtn() {
        let array = ["修改订阅","删除订阅"]
        _ = buildRightDropDown(array)
    }
    
    override func requestData(_ pn: Int,_ refresh: Bool = false) {
        var provider = KeywordApiLoadingProvider
        if items.count() > 0 || refresh{
            provider = KeywordApiProvider
        }
        provider.request(KeywordApi.articles(id: source.id, pn: pn, lastTime:items.last_time),
            model: ArticleList.self) { [weak self] (returnData) in
            self?.callbackResult(returnData,pn:pn)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if pageDataRefreshed {
            pressBack()
        }
    }
}


extension KeywordArticleListController: RightDropDownOpration {
    

    func clickRightDropDownItem(item: String) {
        if !DAOFactory.isLogin() {
            self.showLoginToast()
            return
        }
        if item == "修改订阅" {
            pushViewController(NewKeywordController(source:source))
        } else if item == "删除订阅" {
            clickDelete()
        }
    }
    
    func clickDelete() {
        showConfirmAlert("确定要删除该订阅吗？") {
            self.handleDelete()
        }
    }
    
    func handleDelete() {
        KeywordApiLoadingProvider.request(KeywordApi.delete(id: source.id),
            model: BaseObject.self) { [weak self] (returnData) in
            self?.callbackDeleteResult(returnData)
        }
    }
    
    func callbackDeleteResult(_ returnData:BaseObject?) {
        if !self.showErrorResultAlert(returnData) {
            return
        }
        pageDataRefreshed = true
        showAlert("提示", text: "删除成功") {
            self.pressBack()
        }
    }
}
