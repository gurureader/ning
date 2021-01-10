//
//  CatSourceListController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/20.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class CatSourceListController: BaseListController {

    var items: SourceList = SourceList()
    var catId: Int = 0
    var listType: NingListType = .Hot
    var helper: ControllerUtils?
    
    convenience init(_ catId: Int, listType: NingListType, items: SourceList) {
        self.init()
        self.catId = catId
        self.listType = listType
        self.items = items
        helper = ControllerUtils(controller: self, isHot: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if listType == .Site {
            if hotSiteChanged {
                hotSiteChanged = false
                refreshTable()
                return
            }
        }
        if items.count() > 0 {
            tableView.reloadData()
        }
    }
       
    override func buildTableView() -> UITableView {
        let tableView = super.buildTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: SourceFollowCell.self)
        return tableView
    }
       
    override func requestData(_ pn: Int,_ refresh: Bool = false) {
        if listType == .Topic || (items.count() > 0 && !refresh) {
            tableView.reloadData()
            return
        }
        SiteApiProvider.request(SiteApi.hot(cid: catId),
            model: HotSiteList.self) { [weak self] (returnData) in
             self?.handleResult(returnData)
        }
    }
    
    func handleResult(_ returnData: HotSiteList?) {
        self.tableView.uHead.endRefreshing()
        if !showErrorResultToast(returnData) {
            return
        }
        self.items = SourceList()
        self.items.items = returnData!.items
        self.tableView.reloadData()
    }
    
    @objc func clickFollowBtn(_ sender: UITapGestureRecognizer) {
        let source = items[sender.view!.tag]
        helper?.followSource(listType: listType, item: source, table: tableView, header:nil)
    }
    
}

extension CatSourceListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SourceFollowCell.self)
        cell.model = items[indexPath.row]
        cell.followView.tag = indexPath.row
        let gesture = UITapGestureRecognizer(target: self, action:#selector(clickFollowBtn))
        cell.followView.addGestureRecognizer(gesture)
        return cell
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let source = items[indexPath.row]
        if source != nil {
            showSourceDetail(source!)
        }
    }
    
    open func showSourceDetail(_ source: SourceModel) {
        if listType == .Topic {
            pushViewController(NingTopicArticleListController(source:source,listType: .Topic,isHot: true))
        } else {
            pushViewController(NingSiteArticleListController(source:source,listType: .Site,isHot: true))
        }
    }
}
