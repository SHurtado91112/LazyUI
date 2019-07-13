//
//  LUITextField+LUITextView.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/12/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

open class LUITextField : UITextField {
    
    private var paddingType : LUIPaddingType!
    private var placeholderFontStyleType : LUIFontStyleType!
    
    override open var placeholder: String? {
        didSet {
            let text = self.placeholder ?? ""
            guard let font = self.font?.withStyle(self.placeholderFontStyleType) else { return }
            let color = LUIThemeManager.shared.color(for: .intermidiateText)
            self.attributedPlaceholder = NSAttributedString(string: text, attributes: [
                NSAttributedString.Key.foregroundColor: color,
                NSAttributedString.Key.font : font
            ])
        }
    }
    
    required public init(paddingType: LUIPaddingType = .none, fontSize: LUIFontSizeType = .regular, textFontStyle: LUIFontStyleType = .regular, placeholderFontStyle: LUIFontStyleType = .regular) {
        
        self.paddingType = paddingType
        self.placeholderFontStyleType = placeholderFontStyle
        
        super.init(frame: .zero)
        self.font = LUIFontManager.shared.universalFont
        self.font = self.font?.withSize(fontSize).withStyle(textFontStyle)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        let padding = LUIPaddingManager.shared.paddingRect(for: self.paddingType)
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let padding = LUIPaddingManager.shared.paddingRect(for: self.paddingType)
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        let padding = LUIPaddingManager.shared.paddingRect(for: self.paddingType)
        return bounds.inset(by: padding)
    }
}

open class LUITextView : UITextView {
    
    required public init(paddingType: LUIPaddingType = .none, fontSize: LUIFontSizeType = .regular, textFontStyle: LUIFontStyleType = .regular) {
        super.init(frame: .zero, textContainer: nil)
        
        self.textContainerInset = LUIPaddingManager.shared.paddingRect(for: paddingType)
        self.font = LUIFontManager.shared.universalFont
        self.font = self.font?.withSize(fontSize).withStyle(textFontStyle)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
