//
//  UserInfo.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/6.
//  Copyright © 2020 tuicool. All rights reserved.
//

class UserInfo: BaseObject {

    var id: Int = 0
    var name: String?
    var password: String?
    var email: String?
    var profile: String?
    var token: String?
    var weixin_name: String?
    var weibo_name: String?
    var qq_name: String?
    var is_new: Bool = false
    var is_member: Bool = false
    var notification_num: Int = 0
    var member_period: String?

    func isLogin() -> Bool {
        return id > 0
    }
    
}

class UserWrapper: BaseObject {
    
    var user: UserInfo?
}
