//
//  PreferenceManager.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/23.
//  Copyright © 2020 tuicool. All rights reserved.
//

import Foundation

class PreferenceManager {
    
    static func setShowAgreement() {
        setValue("agreement",1)
    }
    
    static func isShowAgreement() -> Bool{
        return getValue("agreement") != nil
    }

    static func getValue(_ key: String) -> Any? {
        let defaultStand = UserDefaults.standard
        return defaultStand.object(forKey: key)
    }
    static func setValue(_ key: String, _ value: Any) {
        let defaultStand = UserDefaults.standard
        defaultStand.set(value, forKey: key)
    }
}
