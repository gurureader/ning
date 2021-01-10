//
//  BaseObject.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/4.
//  Copyright © 2020 tuicool. All rights reserved.
//

import HandyJSON

class BaseObject: HandyJSON {
    var status: Int = 0
    var success: Bool? = false
    var error: String?
    
    required init() {}
    
    func isSuccess() -> Bool {
        return success == true && status == 0
    }
    
    func isMemberError() -> Bool {
        return status == -100
    }
}

class BaseList<T>: BaseObject {
    
    var items: Array<T> = []
    var has_next: Bool = false
    required init() {}
    
    convenience init(items: Array<T>) {
        self.init()
        self.items = items
    }
    
    open func count() -> Int {
        return items.count
    }
    
    func isEmpty() -> Bool {
        return items.isEmpty
    }
    
    func append(_ t: T) {
        items.append(t)
    }
    
    subscript(index: Int) -> T? {
        get {
            if items.count <= index {
                return nil
            }
            return items[index]
        }
        set(newValue) {
            if items.count < index || newValue == nil {
                return
            }
            items[index] = newValue!
        }
    }
}

class SimpleResult: BaseObject {
    
    var info :String = ""
}
