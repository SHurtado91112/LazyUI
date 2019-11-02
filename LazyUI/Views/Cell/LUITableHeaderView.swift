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

public typealias LUITableHeaderView = LUITableHeaderViewClass & LUICellData
open class LUITableHeaderViewClass: LUIView {
    
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
