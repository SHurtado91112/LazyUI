//
//  LUISearchController.swift
//  LazyUI
//
//  Created by Steven Hurtado on 8/26/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

class LUISearchController: UISearchController, UISearchBarDelegate {

    private lazy var _searchBar: LUISearchBar = {
        let bar = LUISearchBar()
        bar.delegate = self
        return bar
    } ()
    
    override var searchBar: UISearchBar {
        return self._searchBar
    }
}
