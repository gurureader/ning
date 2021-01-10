//
//  TopicApi.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/8.
//  Copyright © 2020 tuicool. All rights reserved.
//

import Moya
import HandyJSON

enum TopicApi {

    case hotAll
    case myAll
    case myDirList
    case show(id: Int,lang: Int = 0, pn: Int = 0)
    case juheReading(id: String, pn: Int = 0, code: String = "")
    case markAllRead
    case markGroupRead(id: Int)
    case follow(id: String)
    case unfollow(id: String)
}

extension TopicApi: TargetType {
    var path: String {
        switch self {
            case .hotAll: return "topics/hot_all.json"
            case .myAll: return "topics/my_all.json"
            case .show(let id,_,_): return "topics/\(id).json"
            case .myDirList: return "topics/my_with_dirs.json"
            case .juheReading: return "topics/juhe_reading.json"
            case .markAllRead: return "topics/mark_all_read.json"
            case .markGroupRead: return "topics/mark_juhe_readed.json"
            case .follow: return "topics/mark_follow.json"
            case .unfollow: return "topics/mark_unfollow.json"
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
        case .show(_, let lang, let pn):
            parmeters["lang"] = lang
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

let TopicApiProvider = MoyaProvider<TopicApi>(manager:DefaultAlamofireManager.sharedManager,plugins: [BasicCredentialsPlugin])

let TopicApiLoadingProvider = MoyaProvider<TopicApi>(manager:DefaultAlamofireManager.sharedManager,plugins: [BasicCredentialsPlugin,LoadingPlugin])

