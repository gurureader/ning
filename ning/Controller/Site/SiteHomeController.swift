//
//  SiteHomeController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/3.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class SiteHomeController: NingMyGroupSourceController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func requestData(_ pn: Int,_ refresh: Bool = false) {
        if refresh {
            SiteApiProvider.request(SiteApi.myDirList,
                       model: SourceDirList.self) { [weak self] (returnData) in
                self?.callbackResult(returnData)
            }
        } else {
            SiteApiLoadingProvider.request(SiteApi.myDirList,
                       model: SourceDirList.self) { [weak self] (returnData) in
                self?.callbackResult(returnData)
            }
        }
        
    }
    
    override func getSourceListType() -> NingListType {
        return .Site
    }
    
}
