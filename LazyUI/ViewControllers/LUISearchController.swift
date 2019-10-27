//
//  LUISearchController.swift
//  LazyUI
//
//  Created by Steven Hurtado on 8/26/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

open class LUISearchController: UISearchController, UISearchBarDelegate {

    private lazy var _searchBar: LUISearchBar = {
        let bar = LUISearchBar()
        bar.delegate = self
        bar.showsCancelButton = false
        
        return bar
    } ()
    
    override open var searchBar: UISearchBar {
        return self._searchBar
    }
    
    public var placeholder: String = "" {
        didSet {
            self.searchBar.searchTextField.placeholder = self.placeholder
        }
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.searchBar.searchTextField.tintColor = UIColor.color(for: .theme)
        self.navigationItem.titleView?.tintColor = UIColor.color(for: .theme)
    }
}
