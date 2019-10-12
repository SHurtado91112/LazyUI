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

open class LUIButton: UIButton, LUIViewThemeProtocol {
    
    // theming protocol
    override open var backgroundColor: UIColor? {
        didSet {
            self.backgroundColorType = self.backgroundColor?.type ?? .empty
        }
    }
    
    override open var tintColor: UIColor! {
        didSet {
            self.tintColorType = self.tintColor.type
        }
    }
    
    private var _backgroundColorType: LUIColorType = .empty
    public var backgroundColorType: LUIColorType {
        get {
            return self._backgroundColorType
        }
        set {
            self._backgroundColorType = newValue
        }
    }
    
    private var _textColorType: LUIColorType = .empty
    public var textColorType: LUIColorType {
        get {
            return self._textColorType
        }
        set {
            self._textColorType = newValue
        }
    }
    
    private var _tintColorType: LUIColorType = .empty
    public var tintColorType: LUIColorType {
        get {
            return self._tintColorType
        }
        set {
            self._tintColorType = newValue
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        self.registerForThemeObserver()
    }
    
    deinit {
        self.unregisterForThemeObserver()
    }
    // end theming protocol
    
    private var forAffirmation: Bool = false
    private var forNegation: Bool = false
    private var isRaised: Bool = false
    private let SCALE_JIGGLE_CONST : CGFloat = 0.95
    
    public var doesJiggle: Bool = true
    
    open var text: String? = "" {
        didSet {
            self.setTitle(self.text, for: .normal)
        }
    }
    
    open var textColor: UIColor = .darkText {
        didSet {
            self.setTitleColor(self.textColor, for: .normal)
            self.textColorType = self.textColor.type
        }
    }
    
    private var style: LUIButtonStyle = .none
    override open var isEnabled: Bool {
        didSet {
            if !self.isEnabled {
                self.setButtonStyle(style: .disabled)
            } else {
                self.setButtonStyle(style: self.style)
            }
        }
    }
    
    open var image : UIImage? {
        didSet {
            if let image = self.image {
                self.setImage(image, for: .normal)
            }
        }
    }
    
    open var padding: LUIPaddingType? {
        didSet {
            guard let padding = self.padding else { return }
            self.contentEdgeInsets = LUIPadding.paddingRect(for: padding)
        }
    }

    required public init(style: LUIButtonStyle = .none, affirmation: Bool = false, negation: Bool = false, raised: Bool = false, paddingType: LUIPaddingType = .none, fontSize: LUIFontSizeType = .regular, textFontStyle: LUIFontStyleType = .regular) {
        
        if affirmation && negation {
            fatalError("LUIButton cannot be used for affirmation AND negation.")
        }
        
        super.init(frame: .zero)

        self.padding = paddingType
        // set twice because didSet is not called in view's init
        self.contentEdgeInsets = LUIPadding.paddingRect(for: paddingType)
        
        self.titleLabel?.font = self.titleLabel?.font?.withSize(fontSize).withStyle(textFontStyle)
        
        self.forAffirmation = affirmation
        self.forNegation = negation
        self.isRaised = raised
        
        self.style = style
        self.setButtonStyle(style: style)
        
        self.addTarget(self, action: #selector(self.touchDown(_:)), for: .touchDown)
        self.addTarget(self, action: #selector(self.touchUp(_:)), for: .touchUpInside)
        self.addTarget(self, action: #selector(self.touchUp(_:)), for: .touchUpOutside)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func onClick(sender: Any, selector: Selector) {
        self.addTarget(sender, action: selector, for: .touchUpInside)
    }
    
    public func setButtonStyle(style: LUIButtonStyle) {
        self.tintColor = UIColor.color(for: .theme)
        let tint = self.tintColor ?? .clear
        let color = self.forAffirmation ? UIColor.color(for: .affirmation) : self.forNegation ? UIColor.color(for: .negation) : style != .disabled ? tint : UIColor.color(for: .intermidiateBackground)
        
        switch style {
            case .filled:
                self.backgroundColor = color
                self.textColor = UIColor.color(for: .lightText)
                break
            case .outlined:
                self.layer.borderWidth = 1.0
                self.layer.borderColor = color.cgColor
                self.textColor = color
                break
            case .disabled:
                self.backgroundColor = color
                self.textColor = UIColor.color(for: .lightText)
                break
            case .none:
                self.textColor = color
                break
        }
        
        if self.isRaised && self.isEnabled {
            self.addShadow()
        }
    }
    
    @objc private func touchDown(_ sender: LUIButton) {
        if !self.doesJiggle {
            return
        }
        
        let time = TimeInterval.timeInterval(for: .minimum)
        UIView.animate(withDuration: time, delay: 0.0, options: .curveEaseOut, animations: {
            self.transform = self.transform.scaledBy(x: self.SCALE_JIGGLE_CONST, y: self.SCALE_JIGGLE_CONST)
        })
        
    }
    
    
    @objc private func touchUp(_ sender: LUIButton) {
        if !self.doesJiggle {
            return
        }
        
        let time = TimeInterval.timeInterval(for: .minimum)
        UIView.animate(withDuration: time, delay: time, options: .curveEaseOut, animations: {
            self.transform = .identity
        }, completion: nil)
        
    }

}

extension LUIButton: LUIThemeProtocol {
    
    @objc func themeUpdated() { // reset colors based on last color type
        self.setButtonStyle(style: self.style)
    }
    
    func registerForThemeObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.themeUpdated), name: LUIThemeUpdateNotification, object: nil)
    }
    
    func unregisterForThemeObserver() {
        NotificationCenter.default.removeObserver(self, name: LUIThemeUpdateNotification, object: nil)
    }
    
}
