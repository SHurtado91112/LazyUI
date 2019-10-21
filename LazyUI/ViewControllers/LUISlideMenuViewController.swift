//
//  LUISlideMenuViewController.swift
//  LazyUI
//
//  Created by Steven Hurtado on 10/21/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

fileprivate let SLIDE_SCREEN_WIDTH: CGFloat = UIScreen.main.bounds.width / 4.0 * 3.0
fileprivate let SLIDE_SCREEN_OFFSET: CGFloat = UIScreen.main.bounds.width / 4.0

class LUISlideMenuTableViewController: LUITableViewController {
    
}

public protocol LUISlideMenuContainer: LUIViewControllerProtocol {
    var slideMenuDelegate: LUISlideMenuDelegate? { get set }
}

public protocol LUISlideMenuDelegate: LUIViewControllerProtocol {
    func openMenu()
}

open class LUISlideMenuViewController: LUIViewController {
    
    private var _mainContentViewController: LUISlideMenuContainer!
    private var _slideMenuContentViewController: LUIViewControllerProtocol!
    private lazy var shadowBackground: UIView = {
        let shadowView = UIView()
        shadowView.backgroundColor = UIColor.color(for: .shadow)
        shadowView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.closeMenu)))
        return shadowView
    } ()
    
    private var mainContentViewController: UIViewController & LUISlideMenuContainer {
        guard let vc = self._mainContentViewController as? UIViewController & LUISlideMenuContainer else {
            fatalError("Main content of lui slide menu must be a view controller.")
        }
        return vc
    }
    
    private var slideMenuPresentedConstraint: NSLayoutConstraint?
    private var slideMenuHiddenConstraint: NSLayoutConstraint?
    private var slideMenuContentViewController: UIViewController & LUIViewControllerProtocol {
        guard let vc = self._slideMenuContentViewController as? UIViewController & LUIViewControllerProtocol else {
            fatalError("Slide menu content of lui slide menu must be a view controller.")
        }
        return vc
    }
    
    required public init(mainContent: LUISlideMenuContainer, slideMenuContent: LUIViewControllerProtocol) {
        super.init(nibName: nil, bundle: nil)
        
        self._mainContentViewController = mainContent
        self._mainContentViewController.slideMenuDelegate = self
        
        self._slideMenuContentViewController = slideMenuContent
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setUpViews() {
        
        self.addChild(self.mainContentViewController)
        self.addChild(self.slideMenuContentViewController)
        
        if let mainContentView = self.mainContentViewController.view,
           let slideContentView = self.slideMenuContentViewController.view {
            self.addView(mainContentView)
            self.fill(mainContentView)
            
            self.addView(self.shadowBackground)
            self.fill(self.shadowBackground)
            
            self.addView(slideContentView)
            slideContentView.width(to: SLIDE_SCREEN_WIDTH)
            slideContentView.height(to: self.view.heightAnchor, constraintOperator: .equal)
            slideContentView.addShadow()
            
            self.view.left(slideContentView, fromLeft: true, paddingType: .none, withSafety: false, constraintOperator: .lessThan)
            
            self.slideMenuHiddenConstraint = self.view.left(slideContentView, fromLeft: false, paddingType: .none, withSafety: false, constraintOperator: .equal)
            self.slideMenuPresentedConstraint = self.view.right(slideContentView, fromLeft: false, padding: SLIDE_SCREEN_OFFSET, withSafety: false, constraintOperator: .equal)
            
            self.slideMenuHiddenConstraint?.isActive = true
            self.slideMenuPresentedConstraint?.isActive = false
            
            // set initial state of shadow background
            slideContentView.alpha = 0.0
            self.shadowBackground.alpha = 0.0
        }
        
    }
    
    private func toggleMenu(_ hide: Bool) {
        
        self.slideMenuHiddenConstraint?.isActive = hide
        self.slideMenuPresentedConstraint?.isActive = !hide
        
        let menuView = self.slideMenuContentViewController.view
        if hide {
            menuView?.fadeOut()
            self.shadowBackground.fadeOut()
        } else {
            menuView?.fadeIn()
            self.shadowBackground.fadeIn()
        }
        
        let speed = TimeInterval.timeInterval(for: .fast)
        UIView.animate(withDuration: speed, delay: 0.0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        })
    }

    @objc public func closeMenu() {
        self.toggleMenu(true)
    }
    
}

extension LUISlideMenuViewController: LUISlideMenuDelegate {
    
    public func openMenu() {
        
        self.toggleMenu(false)
        
    }
    
}
