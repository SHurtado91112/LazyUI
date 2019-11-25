//
//  LUIFontManager.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/3/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

public protocol LUIFont {
    var substituteFont : UIFont { get }
}

public class LUIFontManager: NSObject {
    
    private(set) var universalFont : UIFont!
    private var universalSizes : LUIFontSize!
    
    private override init() {
        
    }

    public static let shared = LUIFontManager()
    
    public func setUniversalFont(named fontName: String = "", for sizes: LUIFontSize? = nil) {
        self.universalSizes = sizes ?? LUIFontSize()
        
        if fontName.isEmpty {
            self.setFont(UIFont.systemFont(ofSize: self.universalSizes.regular))
            return
        }
        
        if let font = UIFont(name: fontName, size: self.universalSizes.regular) {
            self.setFont(font)
        } else {
            fatalError("\(fontName) as a Font Asset does not exist.")
        }
    }
    
    public func font(_ font: UIFont, for size: LUIFontSizeType) -> UIFont? {
        return font.withSize(universalSizes.size(for: size))
    }
    
    private func setFont(_ font: UIFont) {
        self.universalFont = font
    }
}
