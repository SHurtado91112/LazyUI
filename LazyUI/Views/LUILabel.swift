//
//  LUILabel.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/7/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

open class LUILabel: UILabel {
    
    open var lineHeight: LUIPaddingType = .none {
        didSet {
            let paragraphStyle = NSMutableParagraphStyle()
            
            //line height size
            paragraphStyle.lineSpacing = LUIPadding.padding(for: self.lineHeight)
            
            let attrString = NSMutableAttributedString(string: self.text ?? "")
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: NSMakeRange(0, attrString.length))
           
            self.attributedText = attrString
        }
    }
    
    open var doesWrap: Bool = false {
        didSet {
            if self.doesWrap {
                self.numberOfLines = 0
                self.lineBreakMode = .byWordWrapping
            } else {
                self.numberOfLines = 1
                self.lineBreakMode = .byTruncatingTail
            }
        }
    }
    
    required public init(color: LUIColorType = .darkText, fontSize: LUIFontSizeType = .regular, fontStyle: LUIFontStyleType = .regular) {
        super.init(frame: CGRect.zero)
        self.font = self.font.withSize(fontSize).withStyle(fontStyle)
        self.textColor = UIColor.color(for: color)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
