//
//  UINavigationBar+LUIAdditions.swift
//  LazyUI
//
//  Created by Steven Hurtado on 11/6/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

extension UINavigationBar {
    
    open func resetBackground() {
        self.backgroundColor = nil
        self.setBackgroundImage(nil, for: .default)
        self.shadowImage = nil
        self.isTranslucent = false
    }
    
    open func clearBackground() {
        self.backgroundColor = .clear
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
    
}
