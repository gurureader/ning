//
//  SourceArticleListController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/8.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class SourceArticleListController: NingArticleListController {

    var source: SourceModel?
    
    private lazy var navigationBarY: CGFloat = {
        return navigationController?.navigationBar.frame.maxY ?? 0
    }()
    
    private var head: SourceArticleHeader?
    private var helper: ControllerUtils?
    
    func buildSourceArticleHeader() -> SourceArticleHeader {
        if self.source == nil || !self.source!.isJuheSource() {
             return SourceArticleHeader(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 220))
        }
        return NingJuheSourceArticleHeader(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 220))
    }
    
    convenience init(source: SourceModel, listType: NingListType, isHot: Bool) {
        self.init()
        self.source = source
        self.listType = listType
        helper = ControllerUtils(controller: self,isHot: isHot)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        edgesForExtendedLayout = .top
    }

    override func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {(make) in
            make.edges.equalTo(self.view.usnp.edges).priority(.low)
            make.top.equalToSuperview()
        }
        head = buildSourceArticleHeader()
        tableView.tableHeaderView = head
        head!.model = source
        head?.followBtn.addTarget(self, action: #selector(clickFollowBtn), for: .touchUpInside)
    }
    
    @objc func clickFollowBtn() {
        helper?.followSource(listType: listType, item: source, table: nil, header: head)
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        navigationController?.barStyle(.clear)
    }
    
    override func postCallbackResult(_ items: ArticleList) {
        if DAOFactory.isLogin() {
            DAOFactory.getSourceCountDAO(listType).markRead(id: source!.id)
            if items.source != nil {
                source?.followed = items.source!.followed
                head?.model = source
            }
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > (tableView.tableHeaderView!.frame.height - navigationBarY) {
            navigationController?.barStyle(.theme)
            navigationItem.title = source?.name ?? ""
        } else {
            navigationController?.barStyle(.clear)
            navigationItem.title = ""
        }
    }
}
