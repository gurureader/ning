//
//  DiscoverySourceController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/20.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class DiscoverySourceController: BasePageController {

    var navi: Array<SourceModel> = []
    var listType: NingListType = .Topic

    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if pageDataRefreshed {
            pageDataRefreshed = false
            reloadData()
        }
    }
    
    open func reloadData() {

    }

}
