//
//  GroupHeaderCell.swift
//  ning
//
//

import UIKit

protocol GroupHeaderCellDelegate {
    func tapGroupHeaderCell(view: NingGroupHeaderCell)
    func tapGroupHeaderJuhe(view: NingGroupHeaderCell)
}


class NingGroupHeaderCell: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.text
        view.font = UIFont.systemFont(ofSize: 16)
        return view
    }()
    
    lazy var metaLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.text
        view.font = UIFont.systemFont(ofSize: 14)
        view.text = "聚合阅读"
        view.isUserInteractionEnabled = true
        view.textColor = UIColor.lightGray
        view.textAlignment = .right
        return view
    }()
    
    lazy var arrowImgView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ning_indicator_expanded")
        return view
    }()
    
    lazy var lineView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ning_group_header_line")
        return view
    }()

    func setupUI() {
        addSubview(arrowImgView)
        arrowImgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(16)
            make.centerY.equalToSuperview()
        }
        
        addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.left.right.bottom.equalToSuperview()
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(40)
            make.centerY.equalToSuperview()
        }
        
        addSubview(metaLabel)
        metaLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.width.equalTo(100)
            make.centerY.equalToSuperview()
        }

    }
    
    var model: SourceDir? {
        didSet {
            guard let model = model else { return }
            titleLabel.text = model.name
            if model.expend {
                arrowImgView.image = UIImage(named: "ning_indicator_expanded")
            } else {
                arrowImgView.image = UIImage(named: "ning_indicator_unexpanded")
            }
        }
    }
    
    var delegate: GroupHeaderCellDelegate? {
        didSet {
            guard delegate != nil else { return }
            setClickAction(self,  action:#selector(self.tapGroupHeaderCell))
            setClickAction(metaLabel, action: #selector(self.tapGroupHeaderJuhe))
        }
    }
    
    func setClickAction(_ view: UIView, action: Selector?) {
        let gesture = UITapGestureRecognizer(target: self, action:action)
        gesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(gesture)
    }
    
    @objc private func tapGroupHeaderCell() {
        self.delegate?.tapGroupHeaderCell(view: self)
    }
    
    @objc private func tapGroupHeaderJuhe() {
        self.delegate?.tapGroupHeaderJuhe(view: self)
    }
}
