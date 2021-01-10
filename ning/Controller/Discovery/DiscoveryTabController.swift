//
//  DiscoveryTabController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/1.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class DiscoveryTabController: BasePageController {
    
    static func build() -> DiscoveryTabController {
        let titles = ["站点","主题"]
        let controllers = [DiscoverySiteController(), DiscoveryTopicController()]
        return DiscoveryTabController(titles:titles, vcs:controllers,pageStyle: .navgationBarSegment)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
