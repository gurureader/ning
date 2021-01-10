//
//  UserApi.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/6.
//  Copyright © 2020 tuicool. All rights reserved.
//

import Moya
import HandyJSON

enum UploadApi {
    case uploadProfile(data: Data)
}

extension UploadApi: TargetType {
    var path: String {
        return "users/upload_profile.json"
    }
    var method: Moya.Method { return .post }
    var task: Task {
        switch self {
        case .uploadProfile(let data):
            var parmeters: [String : Any] = [:]
            let gifData = MultipartFormData(provider: .data(data), name: "profile", fileName: "avatar.jpg", mimeType: "image/jpeg")
            let multipartData = [gifData]
            parmeters["_up_uid"] = DAOFactory.getLoginUser()?.id
            parmeters["_up_token"] = DAOFactory.getLoginUser()?.token
            return .uploadCompositeMultipart(multipartData, urlParameters:parmeters)
        }
    }
}

let UploadApiLoadingProvider = MoyaProvider<UploadApi>(manager:DefaultAlamofireManager.sharedManager,plugins: [LoadingPlugin])

