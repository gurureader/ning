//
//  SourceUnreadCountDAO.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/14.
//  Copyright © 2020 tuicool. All rights reserved.
//

import Foundation
import SQLite

class SourceUnreadCountDAO {

    var sourceType: NingListType
    var hasLoad: Bool = false
    var data = [String:SourceCount]()
    
    let id = Expression<String>("id")
    let time = Expression<Int64>("time")
    let last_time = Expression<Int64>("last_time")
    let cnt = Expression<Int>("cnt")
    
    init(sourceType: NingListType) {
        self.sourceType = sourceType
        createTable()
        logInfo("init dao \(getTableName())")
    }
    
    func createTable() {
        do {
            let DB = DbManager.instance.dbConnection
            let table = Table(getTableName())
            try DB!.run(table.create(ifNotExists: true){t in
                t.column(id)
                t.column(time)
                t.column(last_time)
                t.column(cnt)
            })
        }catch{
           logError(error)
        }
    }
    
    func checkLoad() {
        if hasLoad {
            return
        }
        logInfo("start checkLoad")
        data = loadAll()
        hasLoad = true
    }
    
    func getTableName() -> String {
        if sourceType == .Site {
            return "site_unread_count"
        }
        return "topic_unread_count"
    }
    
    func getUnreadCount(_ id: String) -> Int {
        let item = getSourceCount(id)
        return item?.cnt ?? 0
    }
    
    func getSourceCount(_ id: String) -> SourceCount? {
        checkLoad()
        return data[id]
    }
    
    private func loadAll() -> [String:SourceCount] {
        var data = [String:SourceCount]()
        guard let DB = DbManager.instance.dbConnection else {
           return data
        }
        do {
            let table = Table(getTableName())
            let items = try DB.prepare(table)
            for item in items {
                let sourceCount = SourceCount()
                sourceCount.id = item[id]
                sourceCount.cnt = item[cnt]
                sourceCount.time = item[time]
                sourceCount.lastTime = item[last_time]
                data[sourceCount.id] = sourceCount
            }
            logInfo("loadAll \(getTableName()) size=\(data.count)")
        } catch {
            logError(error)
        }
        return data
    }
    
    func deleteById(id: String) {
        do {
            guard let DB = DbManager.instance.dbConnection else {
               return
            }
            let table = Table(getTableName())
            let query = table.filter(id == self.id)
            try DB.run(query.delete())
            logInfo("dlete \(getTableName()) for \(id)")
            data.removeValue(forKey: id)
        } catch {
            logError(error)
        }
    }
    
    func deleteAll() {
        do {
            guard let DB = DbManager.instance.dbConnection else {
               return
            }
            let table = Table(getTableName())
            try DB.run(table.delete())
            logInfo("delete all \(getTableName())")
            data.removeAll()
        } catch {
            logError(error)
        }
    }
    
    func markRead(id :String) {
        let item = getSourceCount(id)
        if item == nil || item?.cnt == 0{
            logInfo("markRead no need for \(id)")
            return
        }
        item?.cnt = 0
        update(item: item!)
    }
    
    func markDirRead(sourceDir: SourceDir) {
        for item in sourceDir.items {
            markRead(id: item.id)
        }
        logInfo("markDirRead for \(sourceDir.name)")
    }
    
    func markAllRead() {
        do {
            guard let DB = DbManager.instance.dbConnection else {
               return
            }
            let table = Table(getTableName())
            let update = table.update(cnt <- 0)
            try DB.run(update)
            data = loadAll()
            logInfo("markAllRead for \(getTableName())")
        } catch {
            logError(error)
        }
    }
    
    func save(item: SourceCount) {
        do {
            guard let DB = DbManager.instance.dbConnection else {
               return
            }
            let table = Table(getTableName())
            let insert = table.insert(id <- item.id, cnt <- item.cnt, time <- item.time,last_time <- item.lastTime)
            try DB.run(insert)
            logInfo("save \(getTableName()) cnt=\(item.cnt) for \(item.id)")
            data[item.id] = item
        } catch {
            logError(error)
        }
    }
    
    func update(item: SourceCount) {
        do {
            guard let DB = DbManager.instance.dbConnection else {
               return
            }
            let table = Table(getTableName())
            let query = table.filter(item.id == self.id)
            let update = query.update(cnt <- item.cnt, last_time <- item.lastTime)
            try DB.run(update)
            logInfo("update \(getTableName()) cnt=\(item.cnt) for \(item.id)")
            data[item.id] = item
        } catch {
            logError(error)
        }
    }
}
