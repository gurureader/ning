//
//  TopicApi.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/8.
//  Copyright © 2020 tuicool. All rights reserved.
//

import Moya
import HandyJSON

enum GroupApi {

    case addGroup(type: Int,name: String)
    case removeGroup(type: Int,id: Int)
    case moveItem(type: Int,itemId: String, groupId: Int)
    case transferItems(type: Int,fromGroupId: Int, toGroupId: Int)
    case rename(type: Int,id: Int, name: String)
    case updateGroupOrder(type: Int,order: String)
    case updateSourceOrder(type: Int,did: Int, order: String)
}

extension GroupApi: TargetType {
    var path: String {
        switch self {
            case .addGroup: return "source_groups/add_new.json"
            case .removeGroup: return "source_groups/remove.json"
            case .moveItem: return "source_groups/move.json"
            case .transferItems: return "source_groups/transfer_items.json"
            case .rename: return "source_groups/rename.json"
            case .updateGroupOrder: return "source_groups/sort_groups.json"
            case .updateSourceOrder: return "source_groups/order.json"
        }
    }
    var method: Moya.Method {
        return .post
    }
    var task: Task {
        var parmeters: [String : Any] = [:]
        switch self {
        case .addGroup(let type, let name):
            parmeters["type"] = type
            parmeters["name"] = name
        case .removeGroup(let type, let id):
            parmeters["type"] = type
            parmeters["did"] = id
        case .rename(let type,let id, let name):
            parmeters["type"] = type
            parmeters["id"] = id
            parmeters["name"] = name
        case .moveItem(let type,let itemId, let groupId):
            parmeters["type"] = type
            parmeters["sid"] = itemId
            parmeters["did"] = groupId
        case .transferItems(let type,let fromGroupId, let toGroupId):
            parmeters["type"] = type
            parmeters["fid"] = fromGroupId
            parmeters["tid"] = toGroupId
        case .updateGroupOrder(let type,let order):
            parmeters["type"] = type
            parmeters["order"] = order
        case .updateSourceOrder(let type,let did, let order):
            parmeters["type"] = type
            parmeters["did"] = did
            parmeters["order"] = order
        }
        return .requestParameters(parameters: parmeters, encoding: URLEncoding.default)
    }
}

let GroupApiProvider = MoyaProvider<GroupApi>(manager:DefaultAlamofireManager.sharedManager,plugins: [BasicCredentialsPlugin])

let GroupApiLoadingProvider = MoyaProvider<GroupApi>(manager:DefaultAlamofireManager.sharedManager,plugins: [BasicCredentialsPlugin,LoadingPlugin])

