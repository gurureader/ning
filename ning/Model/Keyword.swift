//
//  Keyword.swift
//  ning
//
//  Created by JianjiaYu on 2020/11/10.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class KeywordRuleItem: BaseObject {
    var kw: String = ""
    var op: Int = 0
    
    func setOpName(_ name: String) {
        if name == "或关系" {
            op = 0
        } else if name == "与关系" {
            op = 1
        }
    }
}


class Keyword: BaseList<KeywordRuleItem> {
    var id: String = ""
    var lang: Int = 1
    var name: String = ""
    var member: Bool = false
    var desc: String = ""
    var rules: Array<KeywordRuleItem> = []
    
    func rebuild() {
        items = rules
    }
    
    func buildRuleParam() -> (String,String) {
        var kw = ""
        var op = ""
        for item in items {
            if item.kw.isEmpty {
                continue
            }
            kw += item.kw + "`"
            op += "\(item.op)`"
        }
        return (kw,op)
    }
    
    func setLangName(_ name: String) {
        if name == "仅中文" {
            lang = 1
        } else if name == "仅英文" {
            lang = 2
        } else if name == "中英混合" {
            lang = 0
        }
    }
    
    static func langName(_ value: Int) -> String {
        switch value {
        case 1:
            return "仅中文"
        case 2:
            return "仅英文"
        default:
            return "中英混合"
        }
    }
}
