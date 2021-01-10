//
//  AboutController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/7.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class AboutGuruController: BaseViewController {
    
    private lazy var aboutView: AboutView = {
        return AboutView()
    }()

    override func setupLayout() {
        view.addSubview(aboutView)
        aboutView.snp.makeConstraints{ $0.edges.equalTo(self.view.usnp.edges) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "关于我们"
    }
    

}
