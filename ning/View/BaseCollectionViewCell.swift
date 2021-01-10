//
//  BaseCollectionViewCell.swift
//  ning
//
//

import UIKit
import Reusable

class BaseCollectionViewCell: UICollectionViewCell,Reusable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupUI() {}
}
