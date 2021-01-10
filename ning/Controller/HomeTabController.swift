//
//  HomeTabController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/1.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class HomeTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isTranslucent = false
        setupLayout()
        loadData()
    }
    
    func setupLayout() {
        let article = ArticleTabController.build()
        addChildController(article,
                           title: "文章",
                           image: UIImage(named: "tab_article_normal"),
                           selectedImage: UIImage(named: "tab_article_selected"))
        let sub = SubTabController.build()
        addChildController(sub,
                           title: "订阅",
                           image: UIImage(named: "tab_sub_normal"),
                           selectedImage: UIImage(named: "tab_sub_selected"))
        let discovery = DiscoveryTabController.build()
        addChildController(discovery,
                           title: "发现",
                           image: UIImage(named: "tab_discovery_normal"),
                           selectedImage: UIImage(named: "tab_discovery_selected"))
        let setting = SettingTabController()
        addChildController(setting,
                           title: "我的",
                           image: UIImage(named: "tab_setting_normal"),
                           selectedImage: UIImage(named: "tab_setting_selected"))
        
    }
    
    func addChildController(_ childController: UIViewController, title:String?, image:UIImage? ,selectedImage:UIImage?) {
        
        childController.title = title
        childController.tabBarItem = UITabBarItem(title: nil,
                                                  image: image?.withRenderingMode(.alwaysOriginal),
                                                  selectedImage: selectedImage?.withRenderingMode(.alwaysOriginal))
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            childController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
        addChild(NingNaviController(rootViewController: childController))
    }
    
    func loadData() {
        if !DAOFactory.isLogin() {
            return
        }
        UserApiProvider.request(UserApi.userInfo,
            model: UserWrapper.self) { [weak self] (returnData) in
            self?.callbackResult(returnData)
        }
    }
    
    open func callbackResult(_ returnData:UserWrapper?) {
        if (returnData == nil) {
            return
        }
        if (!returnData!.isSuccess()) {
            return
        }
        let user = returnData!.user!
        DAOFactory.userDAO.saveUser(user)
    }
}
