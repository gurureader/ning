//
//  ManageTuikanController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/18.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class ManageTuikanController: BaseListController {
    
    var items: SourceList = SourceList()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "管理收藏夹"
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if pageDataRefreshed {
            pageDataRefreshed = false
            showToast("提交成功")
            refreshTable()
        }
    }

    override func buildTableView() -> UITableView {
        let tableView = super.buildTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: ManageTuikanView.self)
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
        self.tableView.reloadData()
    }
    
    @objc func clickEditCell(sender: UIButton) {
        let model = items[sender.tag]
        pushViewController(EditTuikanController(source:model))
    }
    
    @objc func clickRemoveCell(sender: UIButton) {
        guard let model = items[sender.tag] else {return}
        var tip = "确定要删除收藏夹《\(model.name)》吗?"
        if model.ac > 0 {
            tip = "确定要删除收藏夹《\(model.name)》及其下的\(model.ac)篇文章吗?"
        }
        showAlert(tip) {
            self.doRemoveSource(source: model)
        }
    }
    
    private func doRemoveSource(source: SourceModel) {
        TuikanApiLoadingProvider.request(TuikanApi.remove(id:source.idInt()),
            model: BaseObject.self) { [weak self] (returnData) in
            self?.postRemoveSubmit(returnData)
        }
    }
    
    func postRemoveSubmit(_ returnData: BaseObject?) {
        if !self.showErrorResultAlert(returnData) {
            return
        }
        pageDataRefreshed = true
        showToast("删除成功")
        refreshTable()
    }
}


extension ManageTuikanController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ManageTuikanView.self)
        cell.model = items[indexPath.row]
        cell.editBtn.tag = indexPath.row
        cell.removeBtn.tag = indexPath.row
        cell.editBtn.addTarget(self, action: #selector(clickEditCell), for: .touchUpInside)
        cell.removeBtn.addTarget(self, action: #selector(clickRemoveCell), for: .touchUpInside)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
}


