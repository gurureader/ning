//
//  ColdBaseController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/24.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class ColdBaseController: BaseViewController {
    
    var items: SourceDirList = SourceDirList()
    lazy var listType: NingListType = self.getListType()
    var selectIds: [String] = []
    
    open func getListType() -> NingListType {
        return .Topic
    }
    
    private lazy var header: ColdPageHeader = {
        let header = ColdPageHeader(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 35))
        header.setListType(listType)
        return header
    }()
    
    private lazy var collectionView: UICollectionView = {
        let lt = UCollectionViewSectionBackgroundLayout()
        lt.minimumInteritemSpacing = 5
        lt.minimumLineSpacing = 5
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: lt)
        collectionView.backgroundColor = UIColor.background
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        collectionView.scrollIndicatorInsets = collectionView.contentInset
        // 注册cell
        collectionView.register(cellType: NingColdSourceCell.self)
        // 注册头部 尾部
        collectionView.register(supplementaryViewType: ColdSourceHeader.self, ofKind: UICollectionView.elementKindSectionHeader)
        collectionView.uHead = URefreshHeader { [weak self] in self?.loadData(true) }
        collectionView.uempty = UEmptyView(verticalOffset: -(collectionView.contentInset.top)) { self.loadData(true) }
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        buildTopBarRightImageBtn("nav_next")
    }
    
    override func setupLayout() {
        view.addSubview(header)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{(make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(header.snp.bottom)
        }
    }
    
    
    @objc override func onClickTopBarRightBtn() {
        logInfo("selectIds=\(selectIds.count)")
        if listType == .Topic {
            if selectIds.count < 5 {
                showToast("请至少选择5个主题")
                return
            }
        } else if selectIds.count < 2 {
            showToast("请至少选择2个站点")
            return
        }
        let ids = selectIds.joined(separator: ",")
        var target = SignupApi.follow_sites(items: ids)
        if listType == .Topic {
            target = SignupApi.follow_topics(items: ids)
        }
        SignupApiLoadingProvider.request(target,
            model: BaseObject.self) { [weak self] (returnData) in
            self?.callbackSubmitResult(returnData)
        }
    }
    
    func loadData(_ refresh: Bool = false) {
        var provider = SignupApiLoadingProvider
        if items.count() > 0 || refresh {
            provider = SignupApiProvider
        }
        var target = SignupApi.cold_topics
        if listType == .Site {
            target = SignupApi.cold_sites
        }
        provider.request(target,
            model: SourceDirList.self) { [weak self] (returnData) in
            self?.callbackResult(returnData)
        }
    }
    
    open func callbackResult(_ returnData: SourceDirList?) {
        self.collectionView.uHead.endRefreshing()
        if !showErrorResultToast(returnData) {
            if self.items.count() == 0 {
                self.collectionView.uempty?.allowShow = true
            }
            return
        }
        self.collectionView.uempty?.allowShow = false
        self.items = returnData!
        self.collectionView.reloadData()
    }

    func callbackSubmitResult(_ returnData: BaseObject?) {
        if !showErrorResultToast(returnData) {
            return
        }
        if listType == .Topic {
            pushViewController(NingColdSiteController())
        } else {
            reloadApp()
            dissmissPage()
        }
    }
    
    func getSource(indexPath: IndexPath) -> SourceModel? {
        guard let dir = items[indexPath.section] else {return nil}
        return dir[indexPath.row]
    }
    
}

extension ColdBaseController: UCollectionViewSectionBackgroundLayoutDelegateLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let dir = items[section]
        return dir?.count() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let source = getSource(indexPath: indexPath)
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: NingColdSourceCell.self)
        cell.model = source
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let head = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: ColdSourceHeader.self)
        let dir = items[indexPath.section]
        head.model = dir
        return head
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return items.count()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor(Double(screenWidth - 20) / 3.0)
        return CGSize(width: width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: screenWidth, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let source = getSource(indexPath: indexPath) else {return}
        let cell = collectionView.cellForItem(at: indexPath) as! NingColdSourceCell
        if source.checked {
            cell.unchoose()
            selectIds.removeFirst(source.id)
        } else {
            cell.choose()
            selectIds.append(source.id)
        }
        source.checked = !source.checked
    }
}
