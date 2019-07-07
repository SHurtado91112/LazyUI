//
//  LUILabel.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/7/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

open class LUILabel: UILabel {

    override open var text: String? {
        didSet {
            self.sizeToFit()
            self.layoutIfNeeded()
        }
    }
    
    required public init(color: LUIColorType, fontSize: LUIFontSizeType, fontStyle: LUIFontStyleType) {
        super.init(frame: CGRect.zero)
        
        self.font = self.font.withSize(fontSize).withStyle(fontStyle)
        self.textColor = UIColor.color(for: color)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
