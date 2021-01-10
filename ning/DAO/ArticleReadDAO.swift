//
//  ArticleReadDAO.swift
//  ning
//
//  Created by JianjiaYu on 2020/10/10.
//  Copyright © 2020 tuicool. All rights reserved.
//

import Foundation
import SQLite

class ArticleReadDAO {
    
    var articleIds: Set<String> = []
    var hasLoad: Bool = false
    
    let id = Expression<Int64>("id")
    let article_id = Expression<String>("article_id")
    
    init() {
        createTable()
        logInfo("init dao \(getTableName())")
    }
    
    func getTableName() -> String {
        return "article_read_logs"
    }

    func createTable() {
        do {
            let DB = DbManager.instance.dbConnection
            let table = Table(getTableName())
            try DB!.run(table.create(ifNotExists: true){t in
                t.column(id)
                t.column(article_id)
            })
        }catch{
           logError(error)
        }
    }
    
    func checkLoad() {
        if hasLoad {
            return
        }
        articleIds = loadAll()
        hasLoad = true
    }
    
    private func loadAll() -> Set<String> {
        var data = Set<String>()
        guard let DB = DbManager.instance.dbConnection else {
           return data
        }
        do {
            var maxId: Int64 = 0
            let limit = 2
            let sql = "select id,article_id from \(getTableName()) order by id desc"
            let items = try DB.prepare(sql)
            for item in items {
                if (data.count > limit) {
                    maxId = item[0] as! Int64
                    break
                }
                data.insert(item[1] as! String)
            }
            if (maxId > 0) {
                deleteOld(maxId)
            }
            logInfo("loadAll read \(getTableName()) size=\(data.count) maxId=\(maxId)")
        } catch {
            logError(error)
        }
        return data
    }
    
    func deleteOld(_ id: Int64) {
        do {
            guard let DB = DbManager.instance.dbConnection else {
               return
            }
            let sql = "delete from \(getTableName()) where id <= \(id)"
            try DB.run(sql)
            logInfo("deleteOld with \(sql)")
        } catch {
            logError(error)
        }
    }
    
    func save(_ articleId: String) {
        do {
            if (contains(articleId)) {
                return
            }
            guard let DB = DbManager.instance.dbConnection else {
               return
            }
            let table = Table(getTableName())
            let insert = table.insert(id <- Date().milliStamp, article_id <- articleId)
            try DB.run(insert)
            logInfo("save \(getTableName()) for \(articleId)")
            articleIds.insert(articleId)
            articleChanged = true
        } catch {
            logError(error)
        }
    }
    
    func contains(_ article_id: String) -> Bool {
        return articleIds.contains(article_id)
    }
}
