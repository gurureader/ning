//
//  BaseViewController.swift
//  ning
//
//  Created by JianjiaYu on 2020/9/1.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit
import SnapKit
import Then
import Reusable
import Kingfisher
import PMAlertController
import DropDown

protocol RightDropDownOpration {
    func clickRightDropDownItem(item: String)
}

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.background
        
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        setupLayout()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configNavigationBar()
        if pageClosed {
            pageClosed = false
            pressBack()
        }
    }
    
    open func setupLayout() {}

    func configNavigationBar() {
        guard let navi = navigationController else { return }
        if navi.visibleViewController == self {
            navi.barStyle(.theme)
            navi.disablePopGesture = false
            navi.setNavigationBarHidden(false, animated: true)
            if navi.viewControllers.count > 1 {
                let text = getNavLeftBarText()
                if text.count > 0 {
                    let btn = UIButton()
                    let width = self.navigationController!.navigationBar.frame.size.height
                    btn.frame = CGRect(x: 15, y: 0, width: width, height: width)
                    btn.setTitle(text, for: .normal)
                    btn.addTarget(self, action:  #selector(pressBack), for: .touchUpInside)
                    btn.setTitleColor(UIColor.white, for: .normal)
                    btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
                } else {
                    navigationItem.leftBarButtonItem = UIBarButtonItem(image:UIImage(named: "nav_back"),target: self,action: #selector(pressBack))
                }
            }
        }
    }
    
    open func getNavLeftBarText() -> String {
        return "";
    }
    
    func reloadApp() {
        NotificationCenter.default.post(name: Notification.Name("login_success"), object: nil)
    }
    
    @objc func pressBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func pushViewController(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func dissmissPage() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func buildTopBarRightTextBtn(_ text:String) {
        let btn = UIButton()
        let width = self.navigationController!.navigationBar.frame.size.height
        btn.frame = CGRect(x: 15, y: 0, width: width, height: width)
        btn.setTitle(text, for: .normal)
        btn.addTarget(self, action:  #selector(onClickTopBarRightBtn), for: .touchUpInside)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
    }
    
    func buildTopBarRightImageBtn(_ img:String) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: img),
        target: self,action: #selector(onClickTopBarRightBtn))
    }
    
    @objc open func onClickTopBarRightBtn() {
        
    }
    
    open func buildRightDropDown(_ array: [String]) -> DropDown{
        let dropDown = DropDown()
        dropDown.anchorView = navigationItem.rightBarButtonItem
        dropDown.dataSource = array
        dropDown.width = 200
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            dropDown.hide()
            self.handleRightDropDownItem(index: index, item: item)
        }
        dropDown.show()
        return dropDown
    }
    
    open func handleRightDropDownItem(index: Int, item: String) {
        if self as? RightDropDownOpration != nil {
            let op = self as! RightDropDownOpration
            op.clickRightDropDownItem(item: item)
        } else {
            logInfo("dump handleRightDropDownItem")
        }
    }
    
    func showConfirmAlert(_ text:String,action:(() -> Void)? = nil) {
        showConfirmAlert(text,"确认",action: action)
    }
    
    func showConfirmAlert(_ text:String,_ yes: String, action:(() -> Void)? = nil) {
        let alertVC = PMAlertController(title: "提示", description: text, image: nil, style: .alert)
         alertVC.addAction(PMAlertAction(title: "取消", style: .cancel, action: nil))
        let ok = PMAlertAction(title: yes, style: .default, action: action)
        ok.setTitleColor(UIColor.theme, for: UIControl.State())
        alertVC.addAction(ok)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func showAlert(_ text:String,action:(() -> Void)? = nil) {
        showAlert("提示", text: text, action: action)
    }
        
    func showAlert(_ title:String,text:String,action:(() -> Void)? = nil) {
        let alertVC = PMAlertController(title: title, description: text, image: nil, style: .alert)
        let ok = PMAlertAction(title: "确认", style: .default, action: action)
        ok.setTitleColor(UIColor.theme, for: UIControl.State())
        alertVC.addAction(ok)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func showListAlert(_ text:String,items: Array<String>) {
        let alertVC = PMAlertController(title: text, description: "", image: nil, style: .alert)
        for item in items {
            if item == "取消" {
                alertVC.addAction(PMAlertAction(title: "取消", style: .cancel, action: nil))
                continue
            }
            let ok = PMAlertAction(title: item, style: .default, action: { () in
                self.clickListAlertValue(value:item)
            })
            ok.setTitleColor(UIColor.text, for: UIControl.State())
            alertVC.addAction(ok)
        }
        self.present(alertVC, animated: true, completion: nil)
    }
    
    open func clickListAlertValue(value: String) {
        
    }
    
    func showErrorResultAlert(_ result:BaseObject?) -> Bool {
        if (result == nil) {
            showAlert("系统错误")
            return false
        }
        if (!result!.isSuccess()) {
            showAlert(result?.error ?? "未知错误")
            return false
        }
        return true
    }
    
    func showErrorResultToast(_ result:BaseObject?) -> Bool {
        if (result == nil) {
            makeToast("系统错误")
            return false
        }
        if (!result!.isSuccess()) {
            makeToast(result?.error ?? "未知错误")
            return false
        }
        return true
    }
    
    func makeToast(_ text: String) {
        NingUtils.makeToast(text, view: self.view)
    }
    
    func showToast(_ text: String) {
        makeToast(text)
    }
    
    func showLoginToast() {
        makeToast(TIP_LOGIN)
    }
    
    func showMemberTip(_ text:String) {
        makeToast(text)
    }
    
    func subTabChanged(_ listType: NingListType) {
        if listType == .Site {
            subSiteChanged = true
        } else {
            subTopicChanged = true
        }
    }
}


extension BaseViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}
