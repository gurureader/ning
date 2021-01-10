//
//  ArticleDetailHelper.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/9.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class ArticleDetailHelper {

    static func buildHtml(_ article: Article) -> String {
        guard let htmlFile = Bundle.main.path(forResource: "detail", ofType: "html") else { return "" }
        do {
            let htmlContent = try String(contentsOfFile: htmlFile, encoding: String.Encoding.utf8)
            var script = ""
//            if !ThemeManager.isNightMode() && article.content.contains("</pre>") {
//                script = "<script src=\"https://static2.tuicool.com/javascripts/highlight.pack.js\"></script>"
//            }
            let css = buildCss()
            logInfo(css)
            let html = String(format: htmlContent, article.title,css,script,article.title,article.feed_title,article.time,article.content,script,"")
            return html
        } catch {
            return ""
        }
    }

    static func buildCss() -> String {
        guard let htmlFile = Bundle.main.path(forResource: "default", ofType: "css") else { return "" }
        do {
            let htmlContent = try String(contentsOfFile: htmlFile, encoding: String.Encoding.utf8)
            var nightMode = "%@ .post_body, .post_body p, .post_body div, .post_body ol, .post_body ul, .post_body ul li, .post_body ol li, .post_body blockquote {word-break:break-all;text-align:justify;}"
            nightMode = String(format: nightMode, "")
            nightMode = String(format: "%@ .post_body{padding-left:2px;padding-right:2px;}",nightMode)
            var html = String(format: "%@\n%@",htmlContent,nightMode)
            let fontSize = 18
            html = html.replacingOccurrences(of: "#tc-width#", with: String(getHtmlWidth()))
            html = html.replacingOccurrences(of: "#tc-font-smallest#", with: String(fontSize-2))
            html = html.replacingOccurrences(of: "#tc-font-small#", with: String(fontSize-2))
            html = html.replacingOccurrences(of: "#tc-font-largest#", with: String(fontSize + 3))
            html = html.replacingOccurrences(of: "#tc-font-large#", with: String(fontSize + 2))
            html = html.replacingOccurrences(of: "#tc-font#", with: String(fontSize))
            return html
        } catch {
            return ""
        }
    }
    
   static func getHtmlWidth() -> Int {
        return 390
    }
    
}
