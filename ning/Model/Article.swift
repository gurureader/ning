//
//  Article.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/4.
//  Copyright © 2020 tuicool. All rights reserved.
//

import HandyJSON

enum NingListType {
    case Hot
    case Fav
    case Late
    case Topic
    case Site
    case Keyword
    case Search
    
    func groupTypeValue() -> Int {
        if self == .Site {
            return 1
        }
        if self == .Topic {
            return 0
        }
        return 2
    }
}

class Article: BaseObject {
    var id: String = ""
    var feed_title: String = ""
    var img: String = ""
    var title: String = ""
    var content: String = ""
    var url: String = ""
    var like: Int = 0
    var late: Int = 0
    var st: Int = 0
    var lang: Int = 0
    var rectime: String = ""
    var time: String = ""
    var uts: Int64 = 0
    var cmt: Int = 0
    
    required init() {}
    
    func getShowTinme() -> String {
        if !rectime.isEmpty {
            return rectime
        }
        return time
    }
}

class ArticleWrapper: BaseObject {
    var article: Article?
    var site: SourceModel?
    
}
    

class ArticleList: BaseList<Article> {
    
    var articles: Array<Article> = []
    var followed: Bool = false
    var st: Int = 0
    var lang: Int?
    var pn: Int = 0
    var last_time: Int64 = 0
    var image: String?
    var id: String?
    var name: String?
    var site: SourceModel?
    var source: SourceModel?
    var code: String?
    var tip: String?
    var next_tip: String?
    var kans: Array<SourceModel> = []
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.items <-- "articles"
    }
    
    func rebuild() {
        items = articles
        if site != nil {
            source = site
            return
        }
        source = SourceModel()
        source!.id = id ?? ""
        source!.name = name ?? ""
        source!.image = image ?? ""
        source!.lang = lang ?? 0
    }
}
