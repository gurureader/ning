//
//  UserDAO.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/6.
//  Copyright © 2020 tuicool. All rights reserved.
//

import Foundation

class UserDAO {
    
    var user: UserInfo?

    func getUser() -> UserInfo? {
        if (user != nil) {
            return user
        }
        let defaultStand = UserDefaults.standard
        let user2 = UserInfo()
        user2.id = defaultStand.integer(forKey: "id")
        if (user2.id <= 0) {
            user = user2
            return user
        }
        user2.email = defaultStand.string(forKey: "email")
        user2.profile = defaultStand.string(forKey: "profile")
        user2.name = defaultStand.string(forKey: "name")
        user2.weixin_name = defaultStand.string(forKey: "weixin_name")
        user2.weibo_name = defaultStand.string(forKey: "weibo_name")
        user2.qq_name = defaultStand.string(forKey: "qq_name")
        user2.token = defaultStand.string(forKey: "token")
        user2.member_period = defaultStand.string(forKey: "member_period")
        user2.is_member = defaultStand.bool(forKey: "is_member")
        user = user2
        return user
    }
    
    func saveUser(_ user: UserInfo) {
        let defaultStand = UserDefaults.standard
        defaultStand.set(user.id, forKey: "id")
        defaultStand.set(user.email, forKey: "email")
        defaultStand.set(user.profile, forKey: "profile")
        defaultStand.set(user.name, forKey: "name")
        defaultStand.set(user.weixin_name, forKey: "weixin_name")
        defaultStand.set(user.weibo_name, forKey: "weibo_name")
        defaultStand.set(user.qq_name, forKey: "qq_name")
        defaultStand.set(user.token, forKey: "token")
        defaultStand.set(user.is_member, forKey: "is_member")
        defaultStand.set(user.member_period, forKey: "member_period")
        self.user = user
        logInfo("done save user \(user.name)")
    }
    
    func clearUser() {
        let defaultStand = UserDefaults.standard
        let keys = ["id","email","profile","name","weixin_name","token","weibo_name","qq_name","is_member","member_period"]
        for key in keys {
            defaultStand.removeObject(forKey: key)
        }
        self.user = nil
    }
}
