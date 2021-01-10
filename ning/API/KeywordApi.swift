//
//  KeywordApi.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/17.
//  Copyright © 2020 tuicool. All rights reserved.
//

import Moya
import HandyJSON

enum KeywordApi {
    case list
    case articles(id: String,pn:Int,lastTime:Int64)
    case create(name: String,lang: Int,ruleKw:String,ruleOp:String)
    case delete(id: String)
    case info(id: String)
    case update(id: String, name: String,lang: Int,ruleKw:String,ruleOp:String)
    case markAllRead
}

extension KeywordApi: TargetType {
    var path: String {
        switch self {
            case .list: return "keyword.json"
            case .articles: return "keyword/articles.json"
            case .create: return "keyword.json"
            case .delete: return "keyword/delete.json"
            case .update: return "keyword/update_info.json"
            case .markAllRead: return "keyword/mark_read_all.json"
            case .info: return "keyword/info.json"
        }
    }
    var method: Moya.Method {
        switch self {
        case .list,.articles,.info:
            return .get
        default:
            return .post
        }
    }
    var task: Task {
        var parmeters: [String : Any] = [:]
        switch self {
        case .create(let name, let lang,let ruleKw,let ruleOp):
            parmeters["lang"] = lang
            parmeters["name"] = name
            parmeters["rule_kw"] = ruleKw
            parmeters["rule_op"] = ruleOp
        case .update(let id,let name, let lang,let ruleKw,let ruleOp):
            parmeters["id"] = id
            parmeters["lang"] = lang
            parmeters["name"] = name
            parmeters["rule_kw"] = ruleKw
            parmeters["rule_op"] = ruleOp
        case .delete( let id):
            parmeters["id"] = id
        case .info( let id):
            parmeters["id"] = id
        case .articles(let id,let pn,let lastTime):
            parmeters["id"] = id
            parmeters["pn"] = pn
            parmeters["last_time"] = lastTime
        default:
            break
        }
        return .requestParameters(parameters: parmeters, encoding: URLEncoding.default)
    }
}

let KeywordApiProvider = MoyaProvider<KeywordApi>(manager:DefaultAlamofireManager.sharedManager,plugins: [BasicCredentialsPlugin])

let KeywordApiLoadingProvider = MoyaProvider<KeywordApi>(manager:DefaultAlamofireManager.sharedManager,plugins: [BasicCredentialsPlugin,LoadingPlugin])


