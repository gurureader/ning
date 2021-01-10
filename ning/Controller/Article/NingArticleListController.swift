//
//  SubTabController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/1.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class NingArticleListController: BaseListController {
    
    var items: ArticleList = ArticleList()
    var catId: Int = 0
    var listType: NingListType = .Hot
    
    convenience init(_ catId: Int, listType: NingListType = .Hot) {
        self.init()
        self.catId = catId
        self.listType = listType
    }
    
    convenience init(listType: NingListType) {
        self.init(0,listType:listType)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (articleChanged) {
            articleChanged = false
            tableView.reloadData()
        }
    }
    
    override func buildTableView() -> UITableView {
        let tableView = super.buildTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: ArticleViewCell.self)
        return tableView
    }
    
    override func requestData(_ pn: Int,_ refresh: Bool = false) {
        var provider = ArticleApiLoadingProvider
        if items.count() > 0 || refresh{
            provider = ArticleApiProvider
        }
        if catId == 1 {
            provider.request(ArticleApi.rec(pn: pn),
                model: ArticleList.self) { [weak self] (returnData) in
                self?.callbackResult(returnData,pn:pn)
            }
        } else {
            provider.request(ArticleApi.hot(catId: catId, pn: pn),
                model: ArticleList.self) { [weak self] (returnData) in
                    self?.callbackResult(returnData,pn:pn)
            }
        }
    }
    
    open func callbackResult(_ returnData:ArticleList?, pn:Int) {
        self.tableView.uHead.endRefreshing()
        self.tableView.uFoot.endRefreshing()
        if !showErrorResultToast(returnData) {
            if self.items.count() == 0 {
                self.tableView.uempty?.allowShow = true
                logInfo("show empty tableview")
            }
            return
        }
        returnData?.rebuild()
        self.pn = pn
        if pn == 0 {
            self.items.items.removeAll()
        }
        self.items.items.append(contentsOf: returnData?.items ?? [])
        if self.items.count() == 0 {
            self.tableView.uempty?.allowShow = true
        } else {
            self.tableView.uempty?.allowShow = false
        }
        self.tableView.reloadData()
        self.items.has_next = returnData?.has_next ?? false
        if self.items.has_next {
            self.tableView.uFoot.isHidden = false
        } else {
            showNoMoreFooter(returnData?.next_tip)
        }
        self.postCallbackResult(returnData!)
    }
    
    open func postCallbackResult(_ items: ArticleList) {
        
    }


}

extension NingArticleListController : UITableViewDelegate, UITableViewDataSource {
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ArticleViewCell.self)
        cell.model = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = NingArticleDetailController(items[indexPath.row]!)
        pushViewController(vc)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}

