//
//  NingUtils.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/6.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit
import Toast_Swift

class NingUtils {
    
    static func buildGrayBorder(_ view: UIView){
        buildBorder(view, color: UIColor.lightGray)
    }

    static func buildBorder(_ view: UIView, color:UIColor, width: CGFloat = 0.5){
        view.layer.borderColor = color.cgColor
        view.layer.borderWidth = width
    }
    
    static func trim(_ text :String?) -> String {
        if text == nil {
            return ""
        }
        return text!.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    static func makeToast(_ text: String,view:UIView) {
        makeToast(text,view:view,delay:1.5)
    }
        
    static func makeToast(_ text: String,view:UIView, delay:TimeInterval) {
        view.makeToast(text, duration: delay, position: .center)
    }

    static func getCurrentTime() -> Int64 {
        return Date().milliStamp
    }

}
