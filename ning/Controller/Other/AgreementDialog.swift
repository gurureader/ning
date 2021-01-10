//
//  AgreementDialog.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/23.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit

class AgreementDialog: UIViewController {
    
    let width = 300
    let height = 300
    
    private lazy var agreementView: AgreementView = {
        return AgreementView(frame: CGRect(x: 0, y: 0, width: width, height: height))
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        view.addSubview(agreementView)
        agreementView.noView.addTarget(self, action: #selector(clickNo), for: .touchUpInside)
        agreementView.yesView.addTarget(self, action: #selector(clickYes), for: .touchUpInside)
        agreementView.textView.delegate = self
    }
    
    @objc func clickNo() {
        exit(0)
    }
    
    @objc func clickYes() {
        PreferenceManager.setShowAgreement()
        NotificationCenter.default.post(name: Notification.Name("closeAgreementView"), object: nil)
    }
    
}

extension AgreementDialog: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL,
                  in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        logInfo("URL.absoluteString=\(URL.absoluteString)")
        UIApplication.shared.open(URL, options: [:], completionHandler: nil)
        return true
    }
}
