//
//  NingOrder.swift
//  ning
//
//  Created by tuicool on 2020/11/22.
//  Copyright © 2020 tuicool. All rights reserved.
//

class NingOrder: BaseObject {
    
    static let STATE_UNKNOWN: Int64 = 0
    static let STATE_PAY_DONE: Int64 = 1
    static let STATE_VERIFY_DONE: Int64 = 2
    static let STATE_VERIFY_FAIL: Int64 = 3
    
    var id: String = ""
    var transaction_id: String = ""
    var state: Int64 = 0
    var time: Int64 = 0
    var receipt_data: String = ""
}

class AppleOrder: BaseObject {
    var order_no: String = ""
}
