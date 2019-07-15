//
//  UIFont+LUIAdditions.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/5/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import Foundation

extension UIFont {
    
    open func withSize(_ fontSizeType: LUIFontSizeType, substitute: Bool = true) -> UIFont {
        let font = substitute ? self.substituteFont : self
        return LUIFontManager.shared.font(font, for: fontSizeType) ?? font
    }
    
    open func withStyle(_ fontStyleType: LUIFontStyleType, substitute: Bool = true) -> UIFont {
        let size = self.pointSize
        let font = substitute ? self.substituteFont : self
        switch fontStyleType {
        case .bold:
            return font.withTraits(traits: .traitBold, size: size, substitute: substitute)
        case .italics:
            return font.withTraits(traits: .traitItalic, size: size, substitute: substitute)
        case .regular:
            return font.withSize(size)
        }
    }
    
    func withTraits(traits: UIFontDescriptor.SymbolicTraits, size: CGFloat, substitute: Bool = true) -> UIFont {
        let font = substitute ? self.substituteFont : self
        if let descriptor = font.fontDescriptor.withSymbolicTraits(traits) {
            return UIFont(descriptor: descriptor, size: size)
        } else {
            return font
        }
    }
}

extension UIFont : LUIFont {
    open var substituteFont: UIFont {
        return LUIFontManager.shared.universalFont
    }
}
