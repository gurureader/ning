//
//  SourceModel.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/8.
//  Copyright © 2020 tuicool. All rights reserved.
//


class SourceModel: BaseObject {
    var id: String = ""
    var image: String = ""
    var name: String = ""
    var followed: Bool = false
    var lang = 0
    var cnt = 0
    var ac = 0
    var type = 0
    var time: Int64?
    var did = 0
    var checked: Bool = false
    
    func isJuheSource() -> Bool {
        return image == "juhe"
    }
    
    func idInt() -> Int {
        guard let result = Int(id) else {return 0}
        return result
    }

}

class SourceList: BaseList<SourceModel> {
    var name: String = ""

}

class HotTopicList: BaseList<SourceList> {
    
}

class HotSiteList: BaseList<SourceModel>  {
    var navi: Array<SourceModel> = []
    
    func naviCount() -> Int {
        return navi.count
    }
}

class SourceDir: BaseList<SourceModel>  {
    var id: Int = 0
    var name: String = ""
    var expend: Bool = false
    var checked: Bool = false
    
    func idsString() -> String {
        let ids = items.map {$0.id}
        return ids.joined(separator: ",")
    }
    
    func copy() -> SourceDir {
        let dir = SourceDir()
        dir.id = id
        dir.name = name
        dir.expend = expend
        dir.checked = checked
        dir.items = items.map {$0}
        return dir
    }
    
    func rebuild() {
        for item in items {
            item.did = id
        }
    }
    
}

class SourceDirList: BaseList<SourceDir>  {
    
    func getAllSourceCount() -> Int {
        var cnt = 0
        for item in items {
            cnt += item.count()
        }
        return cnt
    }
    
    func idsString() -> String {
        let ids = items.map {String($0.id)}
        return ids.joined(separator: ",")
    }
    
    func buildCustomDirs() -> SourceDirList {
        var result = [SourceDir]()
        for item in items {
            if item.id != 0 {
                result.append(item)
            }
        }
        let list = SourceDirList()
        list.items = result
        return list
    }
    
    func rebuild() {
        for item in items {
            item.rebuild()
        }
    }
}

class SourceCount {
    var id: String = ""
    var cnt: Int = 0
    var time: Int64 = 0
    var lastTime: Int64 = 0
    
    init() {
        
    }
    
    init(source: SourceModel) {
        id = source.id
        cnt = source.cnt
        time = source.time ?? 0
        lastTime = source.time ?? 0
    }
    
}
