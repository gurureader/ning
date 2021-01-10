//
//  DAOFactory.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/6.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class DAOFactory {

    static let userDAO =  UserDAO()
    static let memberOrderDAO =  MemberOrderDAO()
    static let articleReadDAO =  ArticleReadDAO()
    static let siteCountDAO = SourceUnreadCountDAO(sourceType: .Site)
    static let topicCountDAO = SourceUnreadCountDAO(sourceType: .Topic)
    
    static func isLogin() -> Bool {
        let userInfo = userDAO.getUser()
        return userInfo != nil && userInfo!.isLogin()
    }
    
    static func getLoginUser() -> UserInfo? {
        return userDAO.getUser()
    }
    
    static func getSourceCountDAO(_ sourceType: NingListType) -> SourceUnreadCountDAO {
        if sourceType == .Site {
            return siteCountDAO
        }
        return topicCountDAO
    }
    
    static func warm() {
        siteCountDAO.checkLoad()
        topicCountDAO.checkLoad()
        articleReadDAO.checkLoad()
        checkHotArticles()
    }
    
    static func unlogin() {
        userDAO.clearUser()
        siteCountDAO.deleteAll()
        topicCountDAO.deleteAll()
    }
    
    static func checkHotArticles() {
        ArticleApiProvider.request(ArticleApi.hot(catId: 0, pn: 0),
            model: ArticleList.self) { (returnData) in
               logInfo("done checkHotArticles")
        }
    }

}
