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
    
    override open func loadView() {
        self.view = LUIView()
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUp()
    }
    
    // MARK: - Set Up For View Controller's views
    private func setUp() {
        if let lazyVC = self as? LUIViewController {
            lazyVC.setUpViews()
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

extension LUIViewController : LUINavigation {
    // MARK: - Navigation
    public var navigation: LUINavigationViewController?
    
    public func push(to vc: UIViewController) {
        if let navigation = self.navigation {
            navigation.push(to: vc)
        } else {
            self.present(LUINavigationViewController(rootVC: vc))
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
        self.present(vc, animated: true, completion: nil)
    }
    
    public func popOver(_ vc: UIViewController) {
        let popOver = LUIPopOverViewController(contentVC: vc)
        self.addChild(popOver)
        self.addView(popOver.view)
        self.fill(popOver.view)
    }
    
    public func dismissableModalViewController() -> LUINavigationViewController {
        return LUINavigationViewController(rootVC: self, largeTitle: false).forDismissal()
    }
    
}
