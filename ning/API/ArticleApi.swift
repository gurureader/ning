//
//  ArticleAPI.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/4.
//  Copyright © 2020 tuicool. All rights reserved.
//

import Moya
import HandyJSON


enum ArticleApi {
    
    case hot(catId: Int = 0, pn: Int = 0)
    case rec(pn: Int = 0)
    case late(pn: Int = 0)
    case detail(id: String)
    case fav(kanId: Int = 0, pn: Int = 0)
    case doFav(id: String, cat: Int)
    case unFav(id: String)
    case doLate(id: String)
    case cancelLate(id: String)
    case search(kw: String, pn: Int = 0, lang: Int = 0)
    
}

extension ArticleApi: TargetType {
    var path: String {
        switch self {
            case .hot: return "articles/hot.json"
            case .rec: return "articles/rec.json"
            case .late: return "articles/late.json"
            case .detail(let id): return "articles/\(id).json"
            case .fav(let kanId,_): return "kans/\(kanId).json"
            case .doFav: return "articles/do_fav.json"
            case .unFav: return "articles/undo_fav.json"
            case .doLate: return "articles/mark_late.json"
            case .cancelLate: return "articles/mark_read.json"
            case .search: return "articles/search.json"
        }
    }
    var method: Moya.Method {
        switch self {
        case .doFav, .unFav, .doLate, .cancelLate:
            return .post
        default:
            return .get
        }
    }
    var task: Task {
        var parmeters: [String : Any] = [:]
        switch self {
            case .hot(let catId,let pn):
                parmeters["cid"] = catId
                parmeters["pn"] = pn
            case .fav(_,let pn):
                parmeters["pn"] = pn
            case .rec(let pn):
                parmeters["pn"] = pn
            case .late(let pn):
                parmeters["pn"] = pn
            case .doFav(let id,let cat):
                parmeters["id"] = id
                parmeters["cat"] = cat
            case .unFav(let id):
                parmeters["id"] = id
            case .doLate(let id):
                parmeters["article_id"] = id
            case .cancelLate(let id):
                parmeters["article_id"] = id
            case .search(let kw,let pn,let lang):
                parmeters["kw"] = kw
                parmeters["pn"] = pn
                parmeters["lang"] = lang
            default:
                break
        }
        return .requestParameters(parameters: parmeters, encoding: URLEncoding.default)
    }
}


let ArticleApiProvider = MoyaProvider<ArticleApi>(manager: DefaultAlamofireManager.sharedManager,plugins: [BasicCredentialsPlugin])
let ArticleApiLoadingProvider = MoyaProvider<ArticleApi>(manager: DefaultAlamofireManager.sharedManager,plugins: [BasicCredentialsPlugin,LoadingPlugin])

