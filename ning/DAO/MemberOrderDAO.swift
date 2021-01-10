//
//  MemberOrderDAO.swift
//  ning
//
//  Created by tuicool on 2020/11/22.
//  Copyright © 2020 tuicool. All rights reserved.
//

import SQLite

class MemberOrderDAO: NSObject {

    let id = Expression<String>("id")
    let transaction_id = Expression<String>("transaction_id")
    let receipt_data = Expression<String>("receipt_data")
    let create_time = Expression<Int64>("create_time")
    let last_time = Expression<Int64>("last_time")
    let state = Expression<Int64>("state")
    
    override init() {
        super.init()
        self.createTable()
        logInfo("init dao \(getTableName())")
    }
    
    func getTableName() -> String {
        return "user_member_order_infos"
    }
    
    func createTable() {
        do {
            let DB = DbManager.instance.dbConnection
            let table = Table(getTableName())
            try DB!.run(table.create(ifNotExists: true){t in
                t.column(id)
                t.column(transaction_id)
                t.column(create_time)
                t.column(last_time)
                t.column(state)
                t.column(receipt_data)
            })
        }catch{
           logError(error)
        }
    }
    
    func save(item: NingOrder) {
        do {
            guard let DB = DbManager.instance.dbConnection else {
               return
            }
            let table = Table(getTableName())
            let insert = table.insert(id <- item.id, state <- item.state, create_time <- NingUtils.getCurrentTime(), transaction_id <- "", receipt_data <- "",last_time <- 0)
            try DB.run(insert)
            logInfo("save \(getTableName()) for \(item.id)")
        } catch {
            logError(error)
        }
    }
    
    func update(item: NingOrder) {
        do {
            guard let DB = DbManager.instance.dbConnection else {
               return
            }
            let table = Table(getTableName())
            let query = table.filter(item.id == self.id)
            let update = query.update(transaction_id <- item.transaction_id, state <- item.state, receipt_data <- item.receipt_data,last_time <- NingUtils.getCurrentTime())
            try DB.run(update)
            logInfo("update \(getTableName()) cnt=\(item.transaction_id) for \(item.id)")
        } catch {
            logError(error)
        }
    }
    
    func updateState(item: NingOrder) {
        do {
            guard let DB = DbManager.instance.dbConnection else {
               return
            }
            let table = Table(getTableName())
            let query = table.filter(item.id == self.id)
            let update = query.update(state <- item.state,last_time <- NingUtils.getCurrentTime())
            try DB.run(update)
            logInfo("update \(getTableName()) cnt=\(item.transaction_id) for \(item.id)")
        } catch {
            logError(error)
        }
    }
    
    func getFailedOrder() -> NingOrder? {
        do {
            guard let DB = DbManager.instance.dbConnection else {
               return nil
            }
            let sql = "select id,last_time,transaction_id,state,receipt_data from \(getTableName()) where state = 3"
            let items = try DB.prepare(sql)
            for item in items {
                let order = NingOrder()
                order.id = item[0] as! String
                order.time = item[1] as! Int64
                order.transaction_id = item[2] as! String
                order.state = item[3] as! Int64
                order.receipt_data = item[4] as! String
                return order
            }
        } catch {
            logError(error)
        }
        return nil
    }
    
    func getByTransactionId(_ id: String) -> NingOrder? {
        do {
            guard let DB = DbManager.instance.dbConnection else {
               return nil
            }
            let sql = "select id,last_time,transaction_id,state,receipt_data from \(getTableName()) where transaction_id = '\(id)' limit 1"
            let items = try DB.prepare(sql)
            for item in items {
                let order = NingOrder()
                order.id = item[0] as! String
                order.time = item[1] as! Int64
                order.transaction_id = item[2] as! String
                order.state = item[3] as! Int64
                order.receipt_data = item[4] as! String
                return order
            }
        } catch {
            logError(error)
        }
        return nil
    }
}
