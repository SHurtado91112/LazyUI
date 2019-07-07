//
//  UIFont+LUIAdditions.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/5/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import Foundation

extension UIFont {
    
    open func withSize(_ fontSizeType: LUIFontSizeType) -> UIFont {
        return LUIFontManager.shared.font(self, for: fontSizeType) ?? self
    }
    
    open func withStyle(_ fontStyleType: LUIFontStyleType) -> UIFont {
        switch fontStyleType {
        case .bold:
            return self.withTraits(traits: .traitBold)
        case .italics:
            return self.withTraits(traits: .traitItalic)
        }
    }
    
    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep the size as it is
    }
}
