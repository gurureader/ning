//
//  TuikanApi.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/17.
//  Copyright © 2020 tuicool. All rights reserved.
//

import Moya
import HandyJSON

enum TuikanApi {

    case create(name: String,type: Int)
    case remove(id: Int)
    case update(id: Int, name: String,type: Int)
    case migrate(fromId: Int,toId: Int)
    case my
}

extension TuikanApi: TargetType {
    var path: String {
        switch self {
            case .create: return "kans.json"
            case .remove: return "kans/delete.json"
            case .update: return "kans/update_info.json"
            case .migrate: return "kans/migrate.json"
            case .my: return "kans/my.json"

        }
    }
    var method: Moya.Method {
        switch self {
        case .my:
            return .get
        default:
            return .post
        }
    }
    var task: Task {
        var parmeters: [String : Any] = [:]
        switch self {
        case .create(let name, let type):
            parmeters["type"] = type
            parmeters["name"] = name
        case .remove( let id):
            parmeters["id"] = id
        case .update(let id, let name, let type):
            parmeters["type"] = type
            parmeters["id"] = id
            parmeters["name"] = name
        case .migrate(let fromId,let toId):
            parmeters["id"] = fromId
            parmeters["target_id"] = toId
        default:
            break
        }
        return .requestParameters(parameters: parmeters, encoding: URLEncoding.default)
    }
}

let TuikanApiProvider = MoyaProvider<TuikanApi>(manager:DefaultAlamofireManager.sharedManager,plugins: [BasicCredentialsPlugin])

let TuikanApiLoadingProvider = MoyaProvider<TuikanApi>(manager:DefaultAlamofireManager.sharedManager,plugins: [BasicCredentialsPlugin,LoadingPlugin])


