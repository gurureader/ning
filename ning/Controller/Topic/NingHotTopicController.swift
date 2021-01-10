//
//  HotTopicController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/4.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class NingHotTopicController: HotSourceController {

    var items: HotTopicList = HotTopicList()
    
    override open func loadData(_ cid :Int = 0) {
       TopicApiProvider.request(TopicApi.hotAll,
           model: HotTopicList.self) { [weak self] (returnData) in
            self?.handleResult(returnData)
       }
    }
    
    func handleResult(_ returnData: HotTopicList?) {
        if !showErrorResultToast(returnData) {
            return
        }
        self.items = returnData!
        self.collectionView.reloadData()
        self.tableView.reloadData()
    }
    
    
    override open func collectionViewCount() -> Int  {
        return items.count()
    }
    
    override open func tableViewCount() -> Int {
        let item = items[currentIndex]
        if item == nil {
            return 0
        }
        return item!.count()
    }
    
    override open func collectionCellSource(_ index: Int) -> SourceModel? {
        let item = items[index]
        let result = SourceModel()
        result.name = item!.name
        return result
    }
    
    
    override open func tableCellSource(_ index: Int) -> SourceModel? {
        let item = items[currentIndex]
        if item == nil {
            return nil
        }
        return item![index]
    }
    
    
    override open func changeCollectionIndex(_ index: Int) {
        currentIndex = index
        self.collectionView.reloadData()
        self.tableView.reloadData()
    }
    
    override open func showSourceDetail(_ source: SourceModel) {
        pushViewController(NingTopicArticleListController(source:source,listType: .Topic,isHot: true))
    }
}
