//
//  LUIPopOverViewController.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/13/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

open class LUIPopOverViewController: LUIViewController {
    
    static public internal(set) var current: LUIPopOverViewController?
    
    public var isDismissible = true
    public var doesObscure: Bool = true {
        didSet {
            self.backgroundView.isHidden = !self.doesObscure
            self.view.isUserInteractionEnabled = self.doesObscure
        }
    }
    
    private var shadow: UIColor {
        return UIColor.color(for: .shadow)
    }
    
    lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = self.shadow
        
        self.addView(backgroundView)
        self.center(backgroundView)
        self.fill(backgroundView)
        
        return backgroundView
    } ()
    
    private var fillConstraints: [NSLayoutConstraint]?
    private var widthConstraint: NSLayoutConstraint?
    
    lazy var contentView: UIView = {
        let view = UIView()
        self.addView(view)
        self.center(view)
        
        self.fillConstraints = [
            self.view.left(view, fromLeft: true, paddingType: .large, withSafety: false),
            self.view.right(view, fromLeft: false, paddingType: .large, withSafety: false)
        ]
        
        view.width(to: UIScreen.main.bounds.width, constraintOperator: .lessThan)
        view.roundCorners(to: 16.0)
        view.addShadow()
        
        return view
    } ()
    
    lazy var desiredHeight: CGFloat = .zero
    
    private var contentViewController : UIViewController?
    
    public required init(contentVC: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        self.contentViewController = contentVC
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.alpha = 0.0
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.fadeIn()
        self.setUpGestures()
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        LUIKeyboardManager.shared.unregisterEvents()
        
        super.viewDidDisappear(animated)
    }
    
    public func setUpViews() {
        self.view.backgroundColor = .clear
        
        if let vc = self.contentViewController {
            
            self.contentView.backgroundColor = vc.view.backgroundColor
            self.contentView.addSubview(vc.view)
            self.contentView.fill(vc.view, padding: .regular)
            
            self.contentView.height(to: self.desiredHeight, constraintOperator: .greaterThan)
            
            self.addChild(vc)
            self.contentView.alpha = 1.0
        }
        
        self.view.sendSubviewToBack(self.backgroundView)
    }
    
    open func applyFill() {
        self.widthConstraint?.eliminate()
        
        if let constraints = self.fillConstraints {
            for constraint in constraints {
                constraint.isActive = true
            }
        }
    }
    
    open func applyWidth(_ width: CGFloat) {
        self.widthConstraint?.eliminate()
        
        if let constraints = self.fillConstraints {
            for constraint in constraints {
                constraint.isActive = false
            }
        }
        
        self.widthConstraint = self.contentView.width(to: width + 2.0 * LUIPadding.padding(for: .regular)) // include padding
    }
    
    private func setUpGestures() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.popOverTapped))
        self.backgroundView.addGestureRecognizer(tapGesture)

        tapGesture.delegate = self
        tapGesture.cancelsTouchesInView = false
        
    }
    
    @objc private func popOverTapped() {
        self.dismiss()
    }
    
    open func dismiss() {
        if self.isDismissible {
            self.view.fadeOut {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}

extension LUIPopOverViewController : UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !(touch.view?.isDescendant(of: self.contentView) ?? false)
    }
}
