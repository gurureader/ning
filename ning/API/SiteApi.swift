//
//  SiteApi.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/8.
//  Copyright © 2020 tuicool. All rights reserved.
//

import Moya
import HandyJSON

enum SiteApi {

    case hot(cid: Int = 0)
    case show(id: String, pn: Int = 0)
    case juheReading(id: String, pn: Int = 0, code: String = "")
    case myDirList
    case markAllRead
    case markGroupRead(id: Int)
    case follow(id: String)
    case unfollow(id: String)
}

extension SiteApi: TargetType {
    var path: String {
        switch self {
            case .hot: return "sites/hot.json"
            case .show(let id, _): return "sites/\(id).json"
            case .myDirList: return "sites/my_with_dirs.json"
            case .juheReading: return "sites/juhe_reading.json"
            case .markAllRead: return "sites/mark_all_read.json"
            case .markGroupRead: return "sites/mark_juhe_readed.json"
            case .follow: return "sites/mark_follow.json"
            case .unfollow: return "sites/mark_unfollow.json"
        }
    }
    var method: Moya.Method {
        switch self {
        case .markAllRead,.markGroupRead,.follow,.unfollow:
            return .post
        default:
            return .get
        }
    }
    var task: Task {
        var parmeters: [String : Any] = [:]
        switch self {
        case .hot(let cid):
           parmeters["cid"] = cid
        case .show(_, let pn):
            parmeters["pn"] = pn
        case .juheReading(let id, let pn, let code):
            parmeters["id"] = id
            parmeters["pn"] = pn
            parmeters["code"] = code
        case .follow(let id):
            parmeters["id"] = id
        case .unfollow(let id):
            parmeters["id"] = id
        case .markGroupRead(let id):
            parmeters["did"] = id
        default:
            break
        }
        return .requestParameters(parameters: parmeters, encoding: URLEncoding.default)
    }
}

let SiteApiProvider = MoyaProvider<SiteApi>(manager:DefaultAlamofireManager.sharedManager,plugins: [BasicCredentialsPlugin])

let SiteApiLoadingProvider = MoyaProvider<SiteApi>(manager:DefaultAlamofireManager.sharedManager,plugins: [BasicCredentialsPlugin,LoadingPlugin])

