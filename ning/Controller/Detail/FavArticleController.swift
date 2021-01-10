//
//  FavArticleController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/16.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class FavArticleController: BaseListController {

    var items: SourceList = SourceList()
    var article: Article = Article()
    private lazy var tableHeader: FavCangHeader = {
        return FavCangHeader(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 40))
    }()

    convenience init(article: Article) {
        self.init()
        self.article = article
    }
    
    override func getNavLeftBarText() -> String {
        return TIP_CANCEL
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "收藏到文件夹"
        buildTopBarRightTextBtn(TIP_SUBMIT)
        tableHeader.btnView.addTarget(self, action: #selector(clickNewTuikan), for: .touchUpInside)
        tableView.tableHeaderView = tableHeader
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if pageDataRefreshed {
            pageDataRefreshed = false
            showToast("创建成功")
            refreshTable()
        }
    }
    
    @objc private func clickNewTuikan() {
        pushViewController(EditTuikanController(source: nil))
    }
    
    override func buildTableView() -> UITableView {
        let tableView = super.buildTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: NingGroupCangCell.self)
        return tableView
    }
    
    override func requestData(_ pn: Int,_ refresh: Bool = false) {
        var provider = TuikanApiLoadingProvider
        if items.count() > 0 || refresh {
            provider = TuikanApiProvider
        }
        provider.request(TuikanApi.my,
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
        if self.items.count() > 0 {
            self.items[0]?.checked = true
        }
        self.tableView.reloadData()
        logInfo("callbackResult size=\(items.count())")
    }
    
    override func onClickTopBarRightBtn() {
        if items.count() == 0 {
            showToast("请创建一个收藏夹")
            return
        }
        let item = getCheckedItem()
        if item == nil {
            showToast("请选择一个收藏夹")
            return
        }
        guard let cat = Int(item!.id) else {return}
        ArticleApiLoadingProvider.request(ArticleApi.doFav(id: article.id, cat: cat),
            model: Article.self) { [weak self] (returnData) in
            self?.postSubmit(returnData)
        }
    }
    
    private func postSubmit(_ returnData: Article?) {
        if !self.showErrorResultToast(returnData) {
            return
        }
        article.like = returnData!.like
        favArticleDone = true
        pressBack()
    }
    
    private func getCheckedItem() -> SourceModel? {
        for item in items.items {
            if item.checked {
                return item
            }
        }
        return nil
    }
}


extension FavArticleController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: NingGroupCangCell.self)
        cell.source = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        clearCheckStates()
        let model = items[indexPath.row]
        model?.checked = true
        self.tableView.reloadData()
    }
    
    private func clearCheckStates() {
        for item in items.items {
            item.checked = false
        }
    }
}

