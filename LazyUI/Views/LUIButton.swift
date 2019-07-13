//
//  LUIButton.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/12/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit


public enum LUIButtonStyle {
    
    case filled
    case outlined
    case disabled
    case none
    
}

open class LUIButton: UIButton {
    
    private var forAffirmation: Bool = false
    private var forNegation: Bool = false
    private var isRaised: Bool = false
    
    open var text: String = "" {
        didSet {
            self.setTitle(self.text, for: .normal)
            self.sizeToFit()
            self.layoutIfNeeded()
        }
    }
    
    open var textColor: UIColor = .darkText {
        didSet {
            self.setTitleColor(self.textColor, for: .normal)
        }
    }
    
    override open var isEnabled: Bool {
        didSet {
            if !self.isEnabled {
                self.setButtonStyle(style: .disabled)
            }
        }
    }

    required public init(style: LUIButtonStyle = .none, affirmation: Bool = false, negation: Bool = false, raised: Bool = false, paddingType: LUIPaddingType = .none, fontSize: LUIFontSizeType = .regular, textFontStyle: LUIFontStyleType = .regular) {
        
        if affirmation && negation {
            fatalError("LUIButton cannot be used for affirmation AND negation.")
        }
        
        super.init(frame: .zero)
        self.contentEdgeInsets = LUIPaddingManager.shared.paddingRect(for: paddingType)

        self.titleLabel?.font = LUIFontManager.shared.universalFont
        self.titleLabel?.font = self.titleLabel?.font?.withSize(fontSize).withStyle(textFontStyle)
        
        self.forAffirmation = affirmation
        self.forNegation = negation
        self.isRaised = raised
        
        self.setButtonStyle(style: style)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setButtonStyle(style: LUIButtonStyle) {
        let color = self.forAffirmation ? UIColor.color(for: .affirmation) : self.forNegation ? UIColor.color(for: .negation) : style != .disabled ? UIColor.color(for: .theme) : UIColor.color(for: .intermidiateBackground)
        
        switch style {
            case .filled:
                self.backgroundColor = color
                self.textColor = UIColor.color(for: .lightText)
                break
            case .outlined:
                self.layer.borderWidth = 2.0
                self.layer.borderColor = color.cgColor
                self.textColor = color
                break
            case .disabled:
                self.backgroundColor = color
                self.textColor = UIColor.color(for: .lightText)
                break
            case .none:
                break
        }
        
        if self.isRaised && self.isEnabled {
            self.addShadow()
        }
    }

}
