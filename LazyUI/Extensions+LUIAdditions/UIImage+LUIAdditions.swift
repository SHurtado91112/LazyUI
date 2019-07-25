//
//  UIImage+LUIAdditions.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/13/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    open var template : UIImage? {
        return self.withRenderingMode(.alwaysTemplate)
    }
    
    open var original : UIImage? {
        return self.withRenderingMode(.alwaysOriginal)
    }
}

extension UIImage: LUIPreviewContent {
    
}
