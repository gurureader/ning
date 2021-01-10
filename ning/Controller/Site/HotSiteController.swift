//
//  HotSiteController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/4.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class HotSiteController: HotSourceController {

    var items: HotSiteList = HotSiteList()
    var navi: Array<SourceModel> = []
    
    override open func loadData(_ cid :Int = 0) {
       SiteApiProvider.request(SiteApi.hot(cid: cid),
           model: HotSiteList.self) { [weak self] (returnData) in
            self?.handleResult(returnData)
       }
    }
    
    func handleResult(_ returnData: HotSiteList?) {
        if !showErrorResultToast(returnData) {
            return
        }
        self.items = returnData!
        if navi.isEmpty {
            navi = self.items.navi
            self.collectionView.reloadData()
        }
        self.tableView.reloadData()
    }
    
    
    override open func collectionViewCount() -> Int  {
        return navi.count
    }
    
    override open func tableViewCount() -> Int {
        return items.count()
    }
    
    override open func collectionCellSource(_ index: Int) -> SourceModel? {
        let item = navi[index]
        let result = SourceModel()
        result.name = item.name
        return result
    }
    
    
    override open func tableCellSource(_ index: Int) -> SourceModel? {
        return items[index]
    }
    
    
    override open func changeCollectionIndex(_ index: Int) {
        currentIndex = index
        self.collectionView.reloadData()
        let cid = Int(navi[index].id)
        loadData(cid!)
    }
    
    override open func collectionViewHeight() -> Int  {
        return 55
    }
    
    override open func showSourceDetail(_ source: SourceModel) {
        pushViewController(NingSiteArticleListController(source:source,listType: .Site,isHot: true))
    }
}
