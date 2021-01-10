//
//  UserApi.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/6.
//  Copyright © 2020 tuicool. All rights reserved.
//

import Moya
import HandyJSON

enum UserApi {
    
    case loginWithEmail(email: String,password: String)
    case updateEmail(email: String,code: String)
    case checkUpdateEmailCode(email: String)
    case updatePassword(newPassword: String, old: String)
    case updateName(name: String)
    case loginWithSocial(auth: OauthInfo)
    case bindSocial(auth: OauthInfo)
    case cancelSocial(type: Int)
    case memberInfo
    case userInfo
}

extension UserApi: TargetType {
    var path: String {
        switch self {
        case .loginWithEmail: return "login.json"
        case .updateEmail: return "users/modify_email.json"
        case .checkUpdateEmailCode: return "users/check_update_email_code.json"
        case .updatePassword: return "users/update_password.json"
        case .updateName: return "users/update_info.json"
        case .loginWithSocial: return "signup/connect_with_social.json"
        case .bindSocial: return "users/bind_social.json"
        case .cancelSocial: return "users/cancel_social.json"
        case .memberInfo: return "member/apple_info.json"
        case .userInfo: return "users/my_info.json"
        }
    }
    var method: Moya.Method {
        switch self {
        case .memberInfo, .userInfo:
            return .get
        default:
            return .post
        }
    }
    var task: Task {
        var parmeters: [String : Any] = [:]
        switch self {
        case .bindSocial(let auth):
            parmeters["from"] = 2
            parmeters["uid"] = auth.uid
            parmeters["union_id"] = auth.unionId
            parmeters["token"] = auth.token
            parmeters["name"] = auth.name
            parmeters["image"] = auth.profile
            parmeters["type"] = auth.type
        case .cancelSocial(let type):
            parmeters["from"] = 2
            parmeters["type"] = type
        case .loginWithEmail(let email,let password):
            parmeters["email"] = email
            parmeters["password"] = password
        case .updateEmail(let email, let code):
            parmeters["email"] = email
            parmeters["code"] = code
        case .checkUpdateEmailCode(let email):
            parmeters["email"] = email
        case .updateName(let name):
            parmeters["name"] = name
        case .updatePassword(let newPassword,let old):
            parmeters["pwd"] = newPassword
            parmeters["old"] = old
        case .loginWithSocial(let auth):
            parmeters["from"] = 2
            parmeters["uid"] = auth.uid
            parmeters["union_id"] = auth.unionId
            parmeters["token"] = auth.token
            parmeters["name"] = auth.name
            parmeters["image"] = auth.profile
            parmeters["type"] = auth.type
        default:
            break
        }
        return .requestParameters(parameters: parmeters, encoding: URLEncoding.default)
    }
}

let UserApiProvider = MoyaProvider<UserApi>(manager:DefaultAlamofireManager.sharedManager,plugins: [BasicCredentialsPlugin])

let UserApiLoadingProvider = MoyaProvider<UserApi>(manager:DefaultAlamofireManager.sharedManager,plugins: [BasicCredentialsPlugin,LoadingPlugin])

