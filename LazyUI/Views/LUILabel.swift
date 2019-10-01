//
//  LUILabel.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/7/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

open class LUILabel: UILabel, LUIViewProtocol {
    
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
    
    override open var textColor: UIColor! {
        didSet {
            self.textColorType = self.textColor.type
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

extension LUILabel: LUIThemeProtocol {
    
    @objc func themeUpdated() { // reset colors based on last color type
        self.backgroundColor = UIColor.color(for: self.backgroundColorType)
        self.tintColor = UIColor.color(for: self.tintColorType)
        self.textColor = UIColor.color(for: self.textColorType)
    }
    
    func registerForThemeObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.themeUpdated), name: LUIThemeUpdateNotification, object: nil)
    }
    
    func unregisterForThemeObserver() {
        NotificationCenter.default.removeObserver(self, name: LUIThemeUpdateNotification, object: nil)
    }
    
}
