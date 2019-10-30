//
//  LUITableHeaderView.swift
//  LazyUI
//
//  Created by Steven Hurtado on 10/30/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

public protocol LUIHeaderCellData: LUICellData {
    var headerHeight: CGFloat { get set }
}

class LUITableHeaderView: LUIView {
    
    func setUpView() {
        self.configureTableViewHeader()
    }
    
    internal func configureTableViewHeader() {
        
        if let cell = self as? LUIHeaderCellData {
            cell.setUpCell()
        }
        
    }
    
}
