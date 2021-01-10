//
//  ManageTuikanController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/18.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class KeywordListController: BaseListController {
    
    var items: SourceList = SourceList()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if pageDataRefreshed {
            pageDataRefreshed = false
            refreshTable()
        } else if items.count() > 0 {
            tableView.reloadData()
        }
    }

    override func buildTableView() -> UITableView {
        let tableView = super.buildTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: KeywordItemCell.self)
        return tableView
    }
    
    override func requestData(_ pn: Int,_ refresh: Bool = false) {
        if !DAOFactory.isLogin() {
            let result = SourceList()
            result.success = true
            self.callbackResult(result)
            return
        }
        var provider = KeywordApiLoadingProvider
        if items.count() > 0 || refresh {
            provider = KeywordApiProvider
        }
        provider.request(KeywordApi.list,
            model: SourceList.self) { [weak self] (returnData) in
            self?.callbackResult(returnData)
        }
    }
    
    open func callbackResult(_ returnData:SourceList?) {
        self.tableView.uHead.endRefreshing()
        self.tableView.uFoot.endRefreshing()
        if !showErrorResultToast(returnData) {
            return
        }
        self.items = returnData!
        if self.items.isEmpty() {
            self.tableView.uempty?.allowShow = true
        } else {
            self.tableView.uempty?.allowShow = false
        }
        self.tableView.reloadData()
    }
    
    func markAllRead() {
        if items.count() == 0 {
            return
        }
        for item in items.items {
            item.cnt = 0
        }
        tableView.reloadData()
    }
}


extension KeywordListController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: KeywordItemCell.self)
        cell.model = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = items[indexPath.row]!
        item.cnt = 0
        let vc = KeywordArticleListController.build(source: item)
        pushViewController(vc)
    }
}


