//
//  SettingTabController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/1.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class SettingTabController: BaseViewController {
    
    private lazy var sectionArray: Array = {
        return [[["name":"fav", "title": "我的收藏"],
                 ["name":"late", "title": "我的待读"]],
                
                [
                 ["name":"about", "title": "关于我们"]]]
    }()

    private lazy var head: MineHeaderView = {
        return MineHeaderView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 250))
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = UIColor.background
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: BaseTableViewCell.self)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .top
        setProfile()
    }
    
    func setProfile() {
        if DAOFactory.isLogin() {
            head.model = DAOFactory.getLoginUser()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setProfile()
        tableView.reloadData()
    }
    
    override func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {(make) in
            make.edges.equalTo(self.view.usnp.edges).priority(.low)
            make.top.equalToSuperview()
        }
        tableView.tableHeaderView = head
        head.setClickAction(self, action: #selector(clickUserProfile))
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        navigationController?.barStyle(.clear)
        navigationItem.title = ""
    }
    
    @objc private func clickUserProfile(_ sender : UITapGestureRecognizer) {
        logInfo("clickUserProfile")
        if DAOFactory.isLogin() {
            pushViewController(UserInfoController())
            return
        }
        pushViewController(UserLoginController())
    }
}



extension SettingTabController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionArray[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: BaseTableViewCell.self)
        cell.accessoryType = .disclosureIndicator
//        cell.selectionStyle = .default
        let sectionItems = sectionArray[indexPath.section]
        let dict: [String: String] = sectionItems[indexPath.row]
        cell.textLabel?.text = dict["title"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = sectionArray[indexPath.section][indexPath.row]
        switch item["name"] {
            case "fav":
                if DAOFactory.isLogin() {
                    pushViewController(NingTuikanArticleListController())
                } else {
                    showLoginToast()
                }
            case "late":
                if DAOFactory.isLogin() {
                    pushViewController(NingLateArticleListController.build())
                } else {
                    showLoginToast()
                }
            case "feedback":
                break
            case "about":
                pushViewController(AboutGuruController())
            default:
                break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}
