//
//  BaseTableViewCell.swift
//  ning
//
//

import UIKit
import Reusable

class BaseTableViewCell: UITableViewCell ,Reusable{

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.listItemSelected
        self.selectedBackgroundView = bgColorView

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupUI() {}

}

