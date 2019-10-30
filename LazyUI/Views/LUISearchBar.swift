//
//  LUISearchBar.swift
//  LazyUI
//
//  Created by Steven Hurtado on 8/26/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

open class LUISearchBar: UISearchBar, LUIViewProtocol {
    
    public func setUpView() {
        
        self.tintColor = UIColor.color(for: .theme)
        self.searchTextField.font = self.searchTextField.font?.substituteFont
        
        self.searchBarStyle = .minimal
    }
    
    open var searchImage: UIImage? {
        didSet {
            self.setImage(self.searchImage, for: .search, state: .normal)
            self.searchTextField.leftView?.tintColor = UIColor.color(for: .theme)
        }
    }
    
    override open func setShowsCancelButton(_ showsCancelButton: Bool, animated: Bool) {
        super.setShowsCancelButton(false, animated: false)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        self.setUpView()
    }
    
}
