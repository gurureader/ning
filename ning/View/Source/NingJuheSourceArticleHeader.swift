//
//  JuheSourceArticleHeader.swift
//  ning
//
//

import UIKit

class NingJuheSourceArticleHeader: SourceArticleHeader {

    override func setupUI() {
        addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.width.height.equalTo(60)
            make.top.equalToSuperview().offset(80)
            make.centerX.equalToSuperview()
        }
        
        addSubview(nameView)
        nameView.snp.makeConstraints { (make) in
            make.top.equalTo(imgView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
    }

}
