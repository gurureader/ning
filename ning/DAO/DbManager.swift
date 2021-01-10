//
//  DbManager.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/13.
//  Copyright © 2020 tuicool. All rights reserved.
//

import Foundation
import SQLite

class DbManager {

    static let instance = DbManager()
    let dbConnection: Connection?

    private init() {
        let dirs: [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true) as [String]
        let dir = dirs[0]
        let path = dir.appending("/gurureader.sqlite")
        logInfo("The DB Path:\(path)")
        do {
            dbConnection = try Connection.init(path)
            dbConnection?.busyTimeout = 5
            dbConnection?.busyHandler({ tries in
                if tries >= 3 {
                    return false
                }
                return true
            })
        }catch {
            logError(error)
            dbConnection = nil
        }
    }
    
}
