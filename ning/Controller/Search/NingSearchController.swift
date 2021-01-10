//
//  NingSearchController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/7.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class NingSearchController: NingArticleListController {
    
    var kw = ""
    var lang = 1
    var searchBar: UISearchBar?
    
    static func build() -> NingSearchController {
        return NingSearchController(listType:.Search)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildSearchBar()
    }
    
    func buildSearchBar() {
        let searchBar = UISearchBar.init(frame: CGRect(x: 0, y: 0, width: screenWidth - 10, height: 40))
        searchBar.isOpaque = true
        searchBar.clipsToBounds = true
        searchBar.showsCancelButton = false
        searchBar.backgroundColor = UIColor.theme
        searchBar.tintColor = UIColor.white
        searchBar.delegate = self
        searchBar.placeholder = "收入关键词搜索文章标题"
        self.navigationItem.titleView = searchBar
        self.searchBar = searchBar
        searchBar.resignFirstResponder()
    }
    
    override func requestData(_ pn: Int,_ refresh: Bool = false) {
        if kw.isEmpty {
            return
        }
        var provider = ArticleApiLoadingProvider
        if items.count() > 0 || refresh{
            provider = ArticleApiProvider
        }
        provider.request(ArticleApi.search(kw: kw, pn: pn, lang: lang),
            model: ArticleList.self) { [weak self] (returnData) in
            self?.callbackResult(returnData,pn:pn)
        }
    }
}


extension NingSearchController: UISearchBarDelegate {

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = NingUtils.trim(searchBar.text)
        if text.isEmpty || text == kw {
            return
        }
        kw = text
        refreshTable()
    }
}
