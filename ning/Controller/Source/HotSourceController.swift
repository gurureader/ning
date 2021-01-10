//
//  HotSourceController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/8.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class HotSourceController: BaseViewController {
    
    var currentIndex = 0

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.background
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: NingHotCategoryCell.self)
        return collectionView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = UIColor.listItem
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: SourceFollowCell.self)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func setupLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(120)
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
            make.left.equalTo(collectionView.snp.right)
        }
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
    }
    
    open func loadData(_ cid :Int = 0) {
       
    }

    open func collectionViewCount() -> Int  {
        return 0
    }
    
    open func collectionViewHeight() -> Int  {
        return 60
    }
    
    open func tableViewCount() -> Int {
        return 0
    }
    
    open func collectionCellSource(_ index: Int) -> SourceModel? {
        return nil
    }
    
    open func tableCellSource(_ index: Int) -> SourceModel? {
        return nil
    }
    
    open func changeCollectionIndex(_ index: Int) {
        
    }
    
    open func showSourceDetail(_ source: SourceModel) {
        
    }
}


extension HotSourceController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: collectionViewHeight())
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: NingHotCategoryCell.self)
        let source = collectionCellSource(indexPath.row)
        cell.setTitle(title: source?.name ?? "")
        cell.setSelected(selected: indexPath.row == currentIndex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        changeCollectionIndex(indexPath.row)
    }
}

extension HotSourceController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SourceFollowCell.self)
        cell.model = tableCellSource(indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let source = tableCellSource(indexPath.row)
        if source != nil {
            showSourceDetail(source!)
        }
    }
}
