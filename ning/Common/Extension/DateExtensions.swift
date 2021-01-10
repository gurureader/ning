//
//  DateExtensions.swift
//  ning
//
//  Created by JianjiaYu on 2020/10/10.
//  Copyright © 2020 tuicool. All rights reserved.
//


extension Date {

    /// 获取当前 秒级 时间戳 - 10位
    var timeStamp : Int {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        return Int(timeInterval)
    }

    /// 获取当前 毫秒级 时间戳 - 13位
    var milliStamp : Int64 {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        return Int64(round(timeInterval*1000))
    }
}
