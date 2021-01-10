//
//  NingGlobal.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/1.
//  Copyright © 2020 tuicool. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import MJRefresh

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

let TIP_LOGIN = "请登录后操作"
let TIP_CANCEL = "取消"
let TIP_SUBMIT = "提交"
let TIP_MODIFY_DONE = "修改成功"
let UMAppkey = "5f6873e0a4ae0a7f7d096088"
let WeChatAppkey = "wx5cd3e505947858f6"
let WeChatAppSecret = "830ab33c1c457ea465edb541bb1ccb83"
let DOMAIN_MAIN = "gurureader.cn"
var API_HOST = "https://api.gurureader.cn/api/"
//var API_HOST = "http://192.168.1.4:3000/api/"

var subSiteChanged = false
var subTopicChanged = false
var pageClosed = false
var pageDataRefreshed = false
var favArticleDone = false
var hotSiteChanged = false
var hotTopicChanged = false
var articleChanged = false

var topVC: UIViewController? {
    var resultVC: UIViewController?
    resultVC = _topVC(UIApplication.shared.keyWindow?.rootViewController)
    while resultVC?.presentedViewController != nil {
        resultVC = _topVC(resultVC?.presentedViewController)
    }
    return resultVC
}

var isIphoneX: Bool {
    return UI_USER_INTERFACE_IDIOM() == .phone
        && (max(UIScreen.main.bounds.height, UIScreen.main.bounds.width) == 812
            || max(UIScreen.main.bounds.height, UIScreen.main.bounds.width) == 896)
}

private  func _topVC(_ vc: UIViewController?) -> UIViewController? {
    if vc is UINavigationController {
        return _topVC((vc as? UINavigationController)?.topViewController)
    } else if vc is UITabBarController {
        return _topVC((vc as? UITabBarController)?.selectedViewController)
    } else {
        return vc
    }
}


//MARK: print
func logInfo(_ message: Any?, file: String = #file, function: String = #function, lineNumber: Int = #line) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("[\(fileName):funciton:\(function):line:\(lineNumber)]- \(message ?? "")")
    #endif
}

func logError(_ message: Any?, file: String = #file, function: String = #function, lineNumber: Int = #line) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("[\(fileName):funciton:\(function):line:\(lineNumber)]- \(message ?? "")")
    #endif
}


//MARK: SnapKit
extension ConstraintView {
    
    var usnp: ConstraintBasicAttributesDSL {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.snp
        } else {
            return self.snp
        }
    }
}

extension UICollectionView {
    
    func reloadData(animation: Bool = true) {
        if animation {
            reloadData()
        } else {
            UIView .performWithoutAnimation {
                reloadData()
            }
        }
    }
}
