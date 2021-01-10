//
//  ColdSiteController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/24.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class NingColdSiteController: ColdBaseController {
    
    override func getListType() -> NingListType {
        return .Site
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "订阅站点"
    }
}
