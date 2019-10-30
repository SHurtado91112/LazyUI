//
//  LUICollectionHeaderView.swift
//  LazyUI
//
//  Created by Steven Hurtado on 10/30/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

class LUICollectionHeaderView: UICollectionReusableView {
    
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
        
        if let cell = self as? LUICellData {
            cell.setUpCell()
        }
    }
    
}
