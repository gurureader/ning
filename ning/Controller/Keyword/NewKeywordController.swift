//
//  NewKeywordController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/18.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class NewKeywordController: BaseListController {
    
    var items: Keyword = Keyword()
    var source: SourceModel?
    var currentOpBtn: UIButton?
    
    private lazy var head: KeywordRuleHeader = {
        return KeywordRuleHeader(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 210))
    }()
    
    convenience init(source: SourceModel?) {
        self.init()
        self.source = source
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildTopBarRightImageBtn("nav_submit")
        if source == nil {
            self.title = "添加订阅"
        } else {
            self.title = "修改订阅"
        }
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if items.count() > 0 {
            tableView.reloadData()
        }
    }

    override func buildTableView() -> UITableView {
        let tableView = super.buildTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: KeywordRuleItemCell.self)
        tableView.tableHeaderView = head
        tableView.backgroundColor = UIColor.listItem
        tableView.isHidden = true
        return tableView
    }
    
    override func requestData(_ pn: Int,_ refresh: Bool = false) {
        var provider = KeywordApiLoadingProvider
        if items.count() > 0 || refresh {
            provider = KeywordApiProvider
        }
        var id = ""
        if (source != nil) {
            id = source!.id
        }
        provider.request(KeywordApi.info(id: id),
            model: Keyword.self) { [weak self] (returnData) in
            self?.callbackResult(returnData)
        }
    }
    
    func callbackResult(_ returnData:Keyword?) {
        self.tableView.uHead.endRefreshing()
        self.tableView.uFoot.endRefreshing()
        if !showErrorResultToast(returnData) {
            return
        }
        self.items = returnData!
        self.items.rebuild()
        if self.items.isEmpty() {
            self.items.append(KeywordRuleItem())
        }
        tableView.isHidden = false
        head.model = self.items
        buildHeadClickEvent()
        self.tableView.reloadData()
    }
    
    func buildHeadClickEvent() {
        head.langBtn.addTarget(self, action: #selector(clickLangBtn), for: .touchUpInside)
        head.ruleBtn.addTarget(self, action: #selector(clickAddRuleBtn), for: .touchUpInside)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(clickDescView))
        gesture.numberOfTapsRequired = 1
        head.descView.addGestureRecognizer(gesture)
    }
    
    @objc func clickDescView() {
        showAlert(items.desc)
    }
    
    @objc func clickLangBtn() {
        showListAlert("选择数据来源", items: ["仅中文","仅英文","中英混合"])
    }
    
    override func clickListAlertValue(value: String) {
        if value == "仅中文" || value == "仅英文" || value == "中英混合" {
            head.langBtn.setTitle(value, for: .normal)
            items.setLangName(value)
        } else if value == "与关系" || value == "与关系" {
            currentOpBtn?.setTitle(value, for: .normal)
            if currentOpBtn != nil {
                guard let model = items[currentOpBtn!.tag] else {return}
                model.setOpName(value)
            }
        }
    }
    
    @objc func clickAddRuleBtn() {
        if items.count() >= 10 {
            showToast("配置的规则项超过上限")
            return
        }
        items.append(KeywordRuleItem())
        tableView.reloadData()
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        guard let model = items[textField.tag] else {return}
        model.kw = NingUtils.trim(textField.text)
    }
    
    @objc func clickOpCell(sender: UIButton) {
        showListAlert("选择关系", items: ["或关系","与关系"])
        currentOpBtn = sender
    }
    
    @objc func clickRemoveCell(sender: UIButton) {
        items.items.remove(at: sender.tag)
        tableView.reloadData()
    }
    
    override func onClickTopBarRightBtn() {
        if items.count() == 0 {
            return
        }
        if !items.member {
            showConfirmAlert("该功能仅对会员开放","了解会员", action: {
                self.pushViewController(MemberController())
            })
            return
        }
        let name = NingUtils.trim(head.nameText.text)
        if name.count < 2 {
            showToast("名称长度无效")
            return
        }
        let (kw,op) = items.buildRuleParam()
        if kw.isEmpty {
            showToast("无有效规则")
            return
        }
        if source == nil {
            KeywordApiLoadingProvider.request(KeywordApi.create(name: name, lang: items.lang, ruleKw: kw, ruleOp: op),
                                              model: SimpleResult.self) { [weak self] (returnData) in
                                              self?.callbackSubmitResult(returnData)
                                        }
        } else {
            KeywordApiLoadingProvider.request(KeywordApi.update(id:source!.id, name: name, lang: items.lang, ruleKw: kw, ruleOp: op),
                                              model: SimpleResult.self) { [weak self] (returnData) in
                                              self?.callbackSubmitResult(returnData)
                                        }
        }
    }
    
    func callbackSubmitResult(_ returnData:SimpleResult?) {
        if !self.showErrorResultAlert(returnData) {
            return
        }
        pageDataRefreshed = true
        showAlert("提示", text: returnData!.info) {
            self.pressBack()
        }
    }
}


extension NewKeywordController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: KeywordRuleItemCell.self)
        cell.model = items[indexPath.row]
        cell.kwText.tag = indexPath.row
        cell.opBtn.tag = indexPath.row
        cell.deleteBtn.tag = indexPath.row
        cell.kwText.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        cell.opBtn.addTarget(self, action: #selector(clickOpCell), for: .touchUpInside)
        cell.deleteBtn.addTarget(self, action: #selector(clickRemoveCell), for: .touchUpInside)
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

}


