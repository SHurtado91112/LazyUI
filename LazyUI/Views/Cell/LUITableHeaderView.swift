//
//  LUITableHeaderView.swift
//  LazyUI
//
//  Created by Steven Hurtado on 10/30/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

public struct LUIHeaderData {
    public var headerHeight: CGFloat = 0.0
    public var headerTitle: String?
    
    public init(height: CGFloat, title: String) {
        self.headerHeight = height
        self.headerTitle = title
    }
}

open class LUITableHeaderView: LUIView {
    
    required public init() {
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func setUpView() {
        self.configureTableViewHeader()
    }
    
    internal func configureTableViewHeader() {
        
        if let cell = self as? LUICellData {
            cell.setUpCell()
        }
        
    }
    
}
