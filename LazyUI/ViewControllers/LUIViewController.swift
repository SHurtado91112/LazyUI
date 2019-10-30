//
//  LUIViewController.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/7/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

public protocol LUIViewControllerProtocol {
    func setUpViews()
}

public typealias LUIViewController = LUIViewControllerClass & LUIViewControllerProtocol

// should not be subclassed, LUIViewController is to be subclassed
open class LUIViewControllerClass: UIViewController {
    
    // private stored property to allow conformance of navigation property for LUINavigation protocol
    private var _navigation: LUINavigationViewController?
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        LUIKeyboardManager.shared.registerEvents(for: self)
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        LUIKeyboardManager.shared.unregisterEvents()
        super.viewDidDisappear(animated)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUp()
    }
    
    // MARK: - Set Up For View Controller's views
    private func setUp() {
        if let lazyVC = self as? LUIViewController {
            self.view.backgroundColor = UIColor.color(for: .lightBackground)
            lazyVC.setUpViews()
        }
        
        self.setUpGestures()
    }
    
    // MARK: - GESTURE SET UP
    
    private func setUpGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewDidTap))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func viewDidTap(sender: UITapGestureRecognizer) {
        
        // Tap and if the text field wasn't tapped then we dismiss editing
        if let activeTextField = LUIKeyboardManager.shared.activeTextField {
            if sender.view != activeTextField {
                self.view.endEditing(true)
            }
        }
    }
    
    // MARK: - Adding Views and Constraints
    
    public func addView(_ view: UIView) {
        self.view.addSubview(view)
    }
    
    public func centerX(_ view: UIView) {
        self.view.centerX(view)
    }
    
    public func centerY(_ view: UIView) {
        self.view.centerY(view)
    }
    
    public func center(_ view: UIView) {
        self.view.center(view)
    }
    
    public func fill(_ view: UIView, padding: LUIPaddingType = .none) {
        self.view.fill(view, padding: padding)
    }

    override open func addChild(_ childController: UIViewController) {
        super.addChild(childController)
        childController.didMove(toParent: self)
    }
}

extension UIViewController : LUIFont {
    
    public var substituteFont: UIFont {
        return LUIFontManager.shared.universalFont
    }
    
}

extension LUIViewControllerClass : LUINavigation {
    
    public var navigation: LUINavigationViewController? {
        get {
            if let navController = self.navigationController as? LUINavigationViewController, self._navigation == nil || self._navigation != navController {
                self._navigation = navController
            }
            return self._navigation
        }
        set {
            self._navigation = newValue
        }
    }
    
    // MARK: - Navigation
    
    public func push(to vc: UIViewController) {
        if let navigation = self.navigation {
            navigation.push(to: vc)
        } else {
            self.presentNavigation(vc)
        }
    }
    
    public func pop() {
        if let navigation = self.navigation {
            navigation.popViewController(animated: true)
        }
    }
    
    public func popToRoot() {
        if let navigation = self.navigation {
            navigation.popToRootViewController(animated: true)
        }
    }
    
    public func present(_ vc: UIViewController) {
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    public func presentModally(_ vc: UIViewController) {
        vc.modalPresentationStyle = .pageSheet
        self.present(vc, animated: true, completion: nil)
    }
    
    public func presentNavigation(_ vc: UIViewController) {
        let nav = LUINavigationViewController(rootVC: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    public func popOver(_ vc: UIViewController) {
        let popOver = LUIPopOverViewController(contentVC: vc)
        LUIPopOverViewController.current = popOver
        
        let currentWindow: UIWindow? = UIApplication.shared.keyWindow
        currentWindow?.addSubview(popOver.view)
        currentWindow?.fill(popOver.view, padding: .none)
//        self.addChild(popOver)
    }
    
    public func dissmissableNavigation() -> LUINavigationViewController {
        let nav = LUINavigationViewController(rootVC: self, largeTitle: false).forDismissal()
        self.navigation = nav
        return nav
    }
    
}
