//
//  LUIView.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/7/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

internal protocol LUIViewProtocol {
    var backgroundColorType: LUIColorType { get set }
    var textColorType: LUIColorType { get set }
    var tintColorType: LUIColorType { get set }
}

open class LUIView: UIView, LUIViewProtocol {
    
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
}

extension LUIView: LUIThemeProtocol {

    @objc func themeUpdated() { // reset colors based on last color type
        self.backgroundColor = UIColor.color(for: self.backgroundColorType)
        self.tintColor = UIColor.color(for: self.tintColorType)
    }

    func registerForThemeObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.themeUpdated), name: LUIThemeUpdateNotification, object: nil)
    }

    func unregisterForThemeObserver() {
        NotificationCenter.default.removeObserver(self, name: LUIThemeUpdateNotification, object: nil)
    }

}
