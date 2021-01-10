//
//  OauthInfo.swift
//  ning
//
//  Created by tuicool on 2020/10/13.
//  Copyright © 2020 tuicool. All rights reserved.
//

let OAUTH_TYPE_WEIXIN = 4

class OauthInfo: CustomStringConvertible {
    
    var uid: String = ""
    var unionId: String = ""
    var name: String = ""
    var token: String = ""
    var profile: String = ""
    var type: Int = OAUTH_TYPE_WEIXIN
    
    public var description: String {
        return "OauthInfo(uid=\(uid),unionId=\(unionId),name=\(name),token=\(token),profile=\(profile),type=\(type)"
    }
}
