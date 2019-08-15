//
//  LUIKeyboardToolBar.swift
//  LazyUI
//
//  Created by Steven Hurtado on 8/7/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

protocol LUIKeyboardToolBarDelegate {
    func dismissRequested()
    func canGoToPrevious() -> Bool
    func canGoToNext() -> Bool
    func previousFieldRequested()
    func nextFieldRequested()
}

class LUIKeyboardToolBar: UIToolbar {

    var placeHolder: String = "" {
        didSet {
            self.placeHolderLabel.title = self.placeHolder
        }
    }
    
    var keyboardDelegate: LUIKeyboardToolBarDelegate? {
        didSet {
            if let delegate = self.keyboardDelegate {
                self.prevBtn.isEnabled = delegate.canGoToPrevious()
                self.nextBtn.isEnabled = delegate.canGoToNext()
                self.setUpView()
            }
        }
    }
    
    
    private lazy var prevBtn = UIBarButtonItem(title: "Prev.", style: .plain, target: self, action: #selector(self.previousField))
    
    private lazy var nextBtn = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(self.nextField))
    
    private let placeHolderLabel: UIBarButtonItem = {
        return UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    } ()
    
    required public init() {
        super.init(frame: CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setUpView() {
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissKeyboard))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        var items: [UIBarButtonItem] = []
        
        if self.prevBtn.isEnabled {
            items.append(self.prevBtn)
        }
        
        if self.nextBtn.isEnabled {
            items.append(self.nextBtn)
        }
        
        items.append(self.placeHolderLabel)
        items.append(flexibleSpace)
        items.append(doneBtn)
        
        self.setItems(items, animated: false)
        
        self.tintColor = UIColor.color(for: .theme)
        self.barTintColor = UIColor.color(for: .lightBackground)
        
        self.sizeToFit()
    }
    
    @objc func dismissKeyboard() {
        self.keyboardDelegate?.dismissRequested()
    }
    
    @objc func previousField() {
        self.keyboardDelegate?.previousFieldRequested()
    }
    
    @objc func nextField() {
        self.keyboardDelegate?.nextFieldRequested()
    }
    
}
