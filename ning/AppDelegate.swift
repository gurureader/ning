//
//  AppDelegate.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/1.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SwiftyStoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    // 申明手机屏幕旋转方向
    var orientation: UIInterfaceOrientationMask = .portrait
    
    var transaction: PaymentTransaction?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true

        window = UIWindow(frame: UIScreen.main.bounds)
        setupLayout()
        NotificationCenter.default.addObserver(self,selector: #selector(self.setupLayout),name:NSNotification.Name("login_success"),object: nil)
        setUpUM()
        DispatchQueue.global().async {
            DAOFactory.warm()
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let flag = UMSocialManager.default()?.handleOpen(url, options: options)
        return flag!
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        let flag = UMSocialManager.default()?.handleOpen(url)
        return flag!
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        UMSocialManager.default()?.handleUniversalLink(userActivity, options: nil)
        return true
    }
    
    @objc func setupLayout() {
        window?.backgroundColor = UIColor.white
        window?.rootViewController = HomeTabController()
        window?.makeKeyAndVisible()
    }
    
    func setUpUM(){
        // 友盟统计
        MobClick.setAutoPageEnabled(true)
        UMConfigure.setLogEnabled(true)
        UMConfigure.initWithAppkey(UMAppkey, channel: "ios")
        UMSocialGlobal.shareInstance()?.universalLinkDic = [UMSocialPlatformType.wechatSession:"https://gurureader/app/"]
        UMSocialManager.default().openLog(true)
        UMSocialManager.default().setPlaform(UMSocialPlatformType.wechatSession, appKey: WeChatAppkey, appSecret: WeChatAppSecret, redirectURL: nil)
    }

}

