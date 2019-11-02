//
//  LUICollectionHeaderView.swift
//  LazyUI
//
//  Created by Steven Hurtado on 10/30/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

public typealias LUICollectionHeaderView = LUICollectionHeaderViewClass & LUICellData
open class LUICollectionHeaderViewClass: UICollectionReusableView {
    
    convenience public init() {
        self.init(frame: .zero)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureCollectionViewHeader()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureCollectionViewHeader()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.configureCollectionViewHeader()
    }
    
    internal func configureCollectionViewHeader() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.cellTapped))
        tapRecognizer.cancelsTouchesInView = false
        self.addGestureRecognizer(tapRecognizer)
        
        if let cell = self as? LUICellData {
            cell.setUpCell()
        }
    }
    
    @objc internal func cellTapped() {
        
        if let cell = self as? LUICellData {
            cell.action?()
        }
    }
}
