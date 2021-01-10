//
//  BaseCollectionReusableView.swift
//  ning
//
//

import Reusable

class BaseCollectionReusableView: UICollectionReusableView,Reusable {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupUI() {}
}

