//
//  BaseListController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/13.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class BaseListController: BaseViewController {
    
    var pn: Int = 0
    
    lazy var tableView: UITableView = buildTableView()
    
    open func buildTableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: getTableStyle())
        tableView.backgroundColor = UIColor.background
        tableView.tableFooterView = UIView()
        tableView.uHead = URefreshHeader { [weak self] in self?.loadData(false,true) }
        let footer = URefreshFooter { [weak self] in self?.loadData(true) }
        setupFooter(footer)
        tableView.uFoot = footer
        tableView.uFoot.isHidden = true
        tableView.uempty = UEmptyView { [weak self] in self?.loadData() }
        tableView.uempty?.allowShow = false
        return tableView
    }
    
    open func getTableStyle() -> UITableView.Style {
        return .plain
    }
    
    open func showNoMoreFooter(_ text: String?) {
        let footer = tableView.uFoot as? URefreshFooter
        if (footer == nil) {
            return
        }
        if (pn == 0) {
            footer?.isHidden = true
            return
        }
        footer?.isHidden = false
        if (text != nil && text!.count > 0) {
            footer?.setTitle(text!, for: .noMoreData)
        } else {
            footer?.setTitle("没有更多了", for: .noMoreData)
        }
        footer?.endRefreshingWithNoMoreData()
    }
    
    open func setupFooter(_ footer: URefreshFooter) {
        footer.setTitle("没有更多了", for: .noMoreData)
        footer.setTitle("努力加载中...", for: .refreshing)
        footer.setTitle("上拉加载更多", for: .pulling)
        footer.setTitle("上拉加载更多", for: .idle)
        footer.setTitle("上拉加载更多", for: .willRefresh)
    }
   
    override func setupLayout() {
       view.addSubview(tableView)
       tableView.snp.makeConstraints{ $0.edges.equalTo(self.view.usnp.edges) }
   }
    
    open func loadData(_ more: Bool = false,_ refresh: Bool = false) {
        let pn = (more ? ( self.pn + 1) : 0)
        requestData(pn,refresh)
    }
    
    open func requestData(_ pn: Int,_ refresh: Bool = false) {
        
    }
    
    open func refreshTable() {
        self.tableView.uHead.beginRefreshing()
        loadData(false,true)
    }

}

