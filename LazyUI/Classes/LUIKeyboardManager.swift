//
//  LUIKeyboardManager.swift
//  LazyUI
//
//  Created by Steven Hurtado on 8/4/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

open class LUIKeyboardManager: NSObject {

    // public properties
    public static let shared = LUIKeyboardManager()
    
    // private properties
    dynamic private(set) var activeTextField: UIView?
    private var rootOrigin: CGPoint?
    
    private var rootViewController: UIViewController?
    
    private var currentTextFields: [UIResponder] = [] {
        didSet {
            for i in 0..<self.currentTextFields.count {
                
                if let field = self.currentTextFields[i] as? UIView {
                    field.tag = i
                }
                
            }
        }
    }
    
    // private methods
    private override init() {
        super.init()
    }
    
    internal func registerEvents(for viewController: UIViewController) {
        self.rootViewController = viewController
        
        let UIKeyboardWillShow = UIResponder.keyboardWillShowNotification
        let UIKeyboardWillHide = UIResponder.keyboardWillHideNotification
        
        //  Registering for keyboard notification.
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardWillHide, object: nil)
        
        // Registering for text field notification.
        let DidBeginEditing = UITextField.textDidBeginEditingNotification
        let DidEndEditing = UITextField.textDidEndEditingNotification
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.textFieldViewDidBeginEditing(_:)), name: DidBeginEditing, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.textFieldViewDidEndEditing(_:)), name: DidEndEditing, object: nil)
        
        self.rootOrigin = viewController.view.frame.origin
    }
    
    internal func unregisterEvents() {
        let UIKeyboardWillShow = UIResponder.keyboardWillShowNotification
        let UIKeyboardWillHide = UIResponder.keyboardWillHideNotification
        
        //  Registering for keyboard notification.
        NotificationCenter.default.removeObserver(self, name: UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIKeyboardWillHide, object: nil)
        
        // Registering for text field notification.
        let DidBeginEditing = UITextField.textDidBeginEditingNotification
        let DidEndEditing = UITextField.textDidEndEditingNotification
        
        NotificationCenter.default.removeObserver(self, name: DidBeginEditing, object: nil)
        NotificationCenter.default.removeObserver(self, name: DidEndEditing, object: nil)
    }
    
    private func inputAccessoryView() -> LUIKeyboardToolBar {
        let keyboardToolBar = LUIKeyboardToolBar()
        keyboardToolBar.keyboardDelegate = self
        return keyboardToolBar
    }
    
    private func resetContentPosition(_ notification: Notification?) {
        
        guard let rootView = self.rootViewController?.view as? LUIView,
            let rootOrigin = self.rootOrigin else {
            return
        }
        
        rootView.frame = CGRect(x: rootOrigin.x, y: rootOrigin.y, width: rootView.frame.width, height: rootView.frame.height)
    }
    
    func debugFrame(frame: CGRect, color: UIColor) {
        let view = UIView()
        view.frame = frame
        view.layer.borderColor = color.cgColor
        
        if let rootView = UIApplication.shared.delegate?.window {
            rootView?.addSubview(view)
            rootView?.bringSubviewToFront(view)
        }
        
        let speed = TimeInterval.timeInterval(for: .slow)

        UIView.animate(withDuration: speed, animations: {
            view.layer.borderWidth = 3.0
        }) { (finished) in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                UIView.animate(withDuration: speed, animations: {
                    view.layer.borderWidth = 0.0
                }, completion: { (finished2) in
                    view.removeFromSuperview()
                })
            })
        }
    }
    
    private func adjustContentPosition(_ notification: Notification?) {
        
        if let textView = self.activeTextField,
            let rootView = self.rootViewController?.view as? LUIView,
            let info = notification?.userInfo,
            let keyboardValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardFrame = keyboardValue.cgRectValue
            let keyboardFrameInView = rootView.convert(keyboardFrame, from: nil)
            
            guard var textViewInRoot = rootView.convertedFrame(fromSubview: textView) else { return }
            
            var rootRect = rootView.frame
            rootRect.size.height = rootRect.size.height - keyboardFrameInView.size.height
            
            // account for if currently scrolled
            if let rootOrigin = self.rootOrigin {
                if rootOrigin != rootView.frame.origin {
                    let adjustedOriginAmount = rootView.frame.origin.y
                    textViewInRoot.origin.y = textViewInRoot.origin.y + adjustedOriginAmount
                }
            }
            
            let paddingOffset = LUIPadding.padding(for: .regular)
            if !rootRect.contains(textViewInRoot.origin) {
                let scrollAmount = textViewInRoot.origin.y + textViewInRoot.height - rootRect.height + paddingOffset
                rootView.frame = CGRect(x: rootView.frame.origin.x, y: rootView.frame.origin.y - scrollAmount, width: rootView.frame.width, height: rootView.frame.height)
            }
            
        }
        
    }
    
    // public methods
    open func setTextFields(_ fields: [UIResponder]) {
        self.currentTextFields = fields
    }
    
    // selector for keyboard events
    
    @objc func keyboardWillShow(_ notification: Notification?) {
        self.adjustContentPosition(notification)
    }
    
    @objc func keyboardWillHide(_ notification: Notification?) {
        self.resetContentPosition(notification)
    }
    
    // selector for text field events
    @objc func textFieldViewDidBeginEditing(_ notification: Notification?) {
        
        if let textFieldView = notification?.object as? UIView {
            self.activeTextField = textFieldView
                
            if let textField = textFieldView as? UITextField {
                textField.inputAccessoryView = self.inputAccessoryView()
            }
            
            if let textView = textFieldView as? UITextView {
                textView.inputAccessoryView = self.inputAccessoryView()
            }
            
        }
    }
    
    @objc func textFieldViewDidEndEditing(_ notification: Notification?) {
        self.activeTextField = nil
    }
    
}

extension LUIKeyboardManager: LUIKeyboardToolBarDelegate {
    
    func dismissRequested() {
        self.activeTextField?.endEditing(true)
    }
    
    func canGoToPrevious() -> Bool {
        let indexRequested = (self.activeTextField?.tag ?? 0) - 1
        
        if self.currentTextFields.count > 0, indexRequested > -1 {
            return true
        }
        
        return false
    }
    
    func canGoToNext() -> Bool {
        let indexRequested = (self.activeTextField?.tag ?? -1) + 1
        
        if self.currentTextFields.count > 0, indexRequested < self.currentTextFields.count {
            return true
        }
        
        return false
    }
    
    func previousFieldRequested() {
        let indexRequested = (self.activeTextField?.tag ?? 0) - 1
        
        if self.currentTextFields.count > 0, indexRequested > -1 {
            self.currentTextFields[indexRequested].becomeFirstResponder()
        }
    }
    
    func nextFieldRequested() {
        let indexRequested = (self.activeTextField?.tag ?? -1) + 1
        
        if self.currentTextFields.count > 0, indexRequested < self.currentTextFields.count {
            self.currentTextFields[indexRequested].becomeFirstResponder()
        }
    }
    
}
