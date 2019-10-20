//
//  LUIPageControl.swift
//  LazyUI
//
//  Created by Steven Hurtado on 10/2/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

extension LUIPageControl {
    
    public enum VerticalPosition {
        case baseline
        case below
    }
    
    public enum HorizontalPosition {
        case left
        case right
        case center
    }
    
}

public protocol LUIPageControlDelegate {
    func pageControlUpdated(sender: UIPageControl)
}

open class LUIPageControl: UIPageControl, LUIViewProtocol {
    
    private let INDICATOR_ALPHA: CGFloat = 0.5
    
    //theme controlled protocol
    override open var backgroundColor: UIColor? {
        didSet {
            self.backgroundColorType = self.backgroundColor?.type ?? .empty
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
    

    // internal
    var delegate: LUIPageControlDelegate?

    convenience init() {
        self.init(frame: .zero)
        self.setUpView()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setUpView() {
        self.addTarget(self, action: #selector(self.pageValueChanged), for: .valueChanged)
        
        self.registerForThemeObserver()
    }
    
    @objc func pageValueChanged() {
        self.delegate?.pageControlUpdated(sender: self)
    }
    
    override open var currentPageIndicatorTintColor: UIColor? {
        didSet {
            self.tintColorType = self.currentPageIndicatorTintColor?.type ?? .empty
            
            self.pageIndicatorTintColor = UIColor.color(for: self.tintColorType).withAlphaComponent(self.INDICATOR_ALPHA)
        }
    }
    
    deinit {
        self.unregisterForThemeObserver()
    }
}

extension LUIPageControl: LUIThemeProtocol {
    
    @objc func themeUpdated() {
        self.currentPageIndicatorTintColor = UIColor.color(for: self.tintColorType)
    }
    
    func registerForThemeObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.themeUpdated), name: LUIThemeUpdateNotification, object: nil)
    }
    
    func unregisterForThemeObserver() {
        NotificationCenter.default.removeObserver(self, name: LUIThemeUpdateNotification, object: nil)
    }
    
}
