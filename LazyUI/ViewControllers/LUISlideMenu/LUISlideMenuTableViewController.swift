//
//  LUISlideMenuTableViewController.swift
//  LazyUI
//
//  Created by Steven Hurtado on 10/21/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

open class LUISlideMenuTableViewController: LUITableViewController, LUISlideMenuContainer {
    
    public var slideMenuDelegate: LUISlideMenuDelegate?
    
    required convenience public init(actionCellType: LUIActionTableCell.Type, cellIdentifier: String) {
        self.init(cellType: actionCellType, cellIdentifier: cellIdentifier)
    }
    
    required public init(cellType: LUITableCell.Type, cellIdentifier: String, sectionType: LUITableHeaderView.Type? = nil, sectionIdentifier: String? = nil) {
        super.init(cellType: cellType, cellIdentifier: cellIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navBar = self.navigation?.navigationBar {
            navBar.backgroundColor = .clear
            navBar.setBackgroundImage(UIImage(), for: .default)
            navBar.shadowImage = UIImage()
            
            navBar.topItem?.leftBarButtonItem?.target = self
            navBar.topItem?.leftBarButtonItem?.action = #selector(self.closeSlideMenu)
        }
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.centerTable()
    }
    
    private func centerTable() {
        
        let contentSize = self.tableView.contentSize
        let boundsSize = self.tableView.bounds.size
        
        if contentSize.height < boundsSize.height {
            let yOffset = floor(boundsSize.height - contentSize.height) / 2.0
            self.tableView.contentOffset = CGPoint(x: 0, y: -yOffset)
            self.tableView.isScrollEnabled = false
        }
    }
    
    @objc private func closeSlideMenu() {
        self.slideMenuDelegate?.closeMenu()
    }
    
}
