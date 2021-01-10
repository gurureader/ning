//
//  URefresh.swift
//  U17
//
//  Created by charles on 2017/11/10.
//  Copyright © 2017年 None. All rights reserved.
//

import UIKit
import MJRefresh

extension UIScrollView {
    var uHead: MJRefreshHeader {
        get { return mj_header! }
        set { mj_header = newValue }
    }
    
    var uFoot: MJRefreshFooter {
        get { return mj_footer! }
        set { mj_footer = newValue }
    }
}

class URefreshHeader: MJRefreshNormalHeader {
    override func prepare() {
        super.prepare()   
        lastUpdatedTimeLabel?.isHidden = true
        stateLabel?.isHidden = true
    }
}

class URefreshAutoHeader: MJRefreshHeader {}

class URefreshFooter: MJRefreshBackNormalFooter {}

class URefreshAutoFooter: MJRefreshAutoFooter {}
