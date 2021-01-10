//
//  SignupApi.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/24.
//  Copyright © 2020 tuicool. All rights reserved.
//


import Moya
import HandyJSON

enum SignupApi {
    case cold_topics
    case cold_sites
    case follow_topics(items: String)
    case follow_sites(items: String)
    case check_email_code(email: String)
    case registerByEmail(email: String,name: String,code: String, password: String)
}

extension SignupApi: TargetType {
    var path: String {
        switch self {
            case .cold_topics: return "signup/cold_topics.json"
            case .cold_sites: return "signup/cold_sites.json"
            case .follow_topics: return "signup/follow_topics.json"
            case .follow_sites: return "signup/follow_sites.json"
            case .check_email_code: return "signup/check_email_code.json"
            case .registerByEmail: return "signup/register_by_email.json"
        }
    }
    var method: Moya.Method {
        switch self {
        case .cold_topics, .cold_sites:
            return .get
        default:
            return .post
        }
    }
    var task: Task {
        var parmeters: [String : Any] = [:]
        switch self {
        case .follow_topics(let items):
            parmeters["items"] = items
        case .follow_sites(let items):
            parmeters["items"] = items
        case .check_email_code(let email):
            parmeters["email"] = email
        case .registerByEmail(let email,let name,let code,let password):
            parmeters["email"] = email
            parmeters["name"] = name
            parmeters["code"] = code
            parmeters["password"] = password
        default:
            break
        }
        return .requestParameters(parameters: parmeters, encoding: URLEncoding.default)
    }
}

let SignupApiProvider = MoyaProvider<SignupApi>(manager:DefaultAlamofireManager.sharedManager,plugins: [BasicCredentialsPlugin])

let SignupApiLoadingProvider = MoyaProvider<SignupApi>(manager:DefaultAlamofireManager.sharedManager,plugins: [BasicCredentialsPlugin,LoadingPlugin])


