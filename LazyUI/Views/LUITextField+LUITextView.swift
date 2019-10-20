//
//  LUITextField+LUITextView.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/12/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

open class LUITextField : UITextField, LUIViewThemeProtocol {
    
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
    // end theming protocol

    
    // MARK: - Public
    open var errorValidator: ((String?)->Bool)?
    open var errorString: String? {
        didSet {
            self.errorLabel.text = self.errorString
        }
    }
    
    open var errorPosition: NSTextAlignment = .right {
        didSet {
            self.errorLabel.textAlignment = self.errorPosition
        }
    }
    
    open var errorSpace: LUIPaddingType = .none { // should only be set ONCE, or susceptible to inconsistent constraint behavior
        didSet {
            self.bottom(self.errorLabel, fromTop: true, paddingType: self.errorSpace, withSafety: false, constraintOperator: .greaterThan)
        }
    }
    
    open var maxCharacterLength: Int = 0 {
        didSet {
            if self.maxCharacterLength > 0 {
                self.addTarget(self, action: #selector(self.textDidChange), for: .editingChanged)
            } else {
                self.removeTarget(self, action: #selector(self.textDidChange), for: .editingChanged)
            }
        }
    }
    
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
    
    // MARK: - Private
    private var paddingType : LUIPaddingType!
    private var placeholderFontStyleType : LUIFontStyleType!
    
    private lazy var errorLabel: LUILabel = {
        let label = LUILabel(color: .negation, fontSize: .small, fontStyle: .italics)
        label.textAlignment = self.errorPosition
        label.lineHeight = .regular
        
        self.addSubview(label)
        self.bottom(label, fromTop: true, paddingType: .none, withSafety: false, constraintOperator: .greaterThan)
        self.left(label, fromLeft: true, paddingType: .none, withSafety: false)
        self.right(label, fromLeft: false, paddingType: .none, withSafety: false)
        
        label.isHidden = true
        
        return label
    } ()
    
    required public init(paddingType: LUIPaddingType = .none, fontSize: LUIFontSizeType = .regular, textFontStyle: LUIFontStyleType = .regular, placeholderFontStyle: LUIFontStyleType = .regular) {
        
        self.paddingType = paddingType
        self.placeholderFontStyleType = placeholderFontStyle
        
        super.init(frame: .zero)
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
    
    public func validate() -> Bool {
        if let validator = self.errorValidator, !validator(self.text) {
            self.errorLabel.isHidden = false
            return false
        } else {
            self.errorLabel.isHidden = true
        }
        return true
    }
    
    @objc private func textDidChange() {
        guard let text = self.text else { return }
        let trimmed = text.prefix(self.maxCharacterLength)
        self.text = String(trimmed)
    }
}

extension LUITextField: LUIThemeProtocol {
    
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


open class LUITextView : UITextView, LUIViewThemeProtocol {
    
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
    // end theming protocol
    
    private var isBuilding: Bool = false
    
    open var viewOnly: Bool = false {
        didSet {
            self.isUserInteractionEnabled = true
            self.isEditable = !self.viewOnly
            self.isScrollEnabled = !self.viewOnly
        }
    }
    
    override open var font: UIFont? {
        get {
            return super.font ?? UIFont().substituteFont
        }
        set {
            super.font = newValue
        }
    }
    
    required public init(paddingType: LUIPaddingType = .none, fontSize: LUIFontSizeType = .regular, textFontStyle: LUIFontStyleType = .regular) {
        super.init(frame: .zero, textContainer: nil)
        
        self.textContainerInset = LUIPaddingManager.shared.paddingRect(for: paddingType)
        self.font = self.font?.withSize(fontSize).withStyle(textFontStyle)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // erases current text for text building session
    public func beginBuilding() {
        self.isBuilding = true
        self.text = ""
    }
    
    public func endBuilding() {
        self.isBuilding = false
        
        let fixedWidth = self.frame.size.width
        let newSize = self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        self.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
    }
    
    public func addText(_ text: String, textColor: UIColor) {
        
        guard let font = self.font else {
            fatalError("Invalid font for text view")
        }
        
        if !self.isBuilding {
            fatalError("Accessing building function when 'beginBuilding' has not been called.")
        }
        
        let newText = NSAttributedString(string: text, attributes: [
            .foregroundColor: textColor,
            .font: font
        ])
        
        let attributedText = NSMutableAttributedString(attributedString: self.attributedText)
        attributedText.append(newText)
        self.attributedText = attributedText
    }
    
    public func addLink(_ text: String, linkColor: UIColor, urlStr: String) {
        
        guard let font = self.font else {
            fatalError("Invalid font for text view")
        }
        
        if !self.isBuilding {
            fatalError("Accessing building function when 'beginBuilding' has not been called.")
        }
        
        if let url = URL(string: urlStr) {
            
            let attributedLink = NSMutableAttributedString(string: text)
            attributedLink.setAttributes([
                .link: url,
                .font: font
            ], range: NSMakeRange(0, text.count))
            
            let leftOverText = NSMutableAttributedString(attributedString: self.attributedText)
            leftOverText.append(attributedLink)
            self.attributedText = leftOverText
            self.linkTextAttributes = [
                .foregroundColor: linkColor
            ]
            
            // assumption for when links are involved, can be changed on client end
            self.viewOnly = true
        } else {
            fatalError("\(urlStr) is not a valid URL.")
        }
    }
    
}

extension LUITextView: LUIThemeProtocol {
    
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
