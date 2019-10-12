//
//  LUIActivityIndicatorView.swift
//  LazyUI
//
//  Created by Steven Hurtado on 10/11/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

open class LUIActivityIndicatorView {
    
    public enum PresentationStyle {
        case small
        case large
        case full
    }
    
    private lazy var _wrapperVC: UIViewController = {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.color(for: .lightBackground)
        vc.view.addSubview(self.activityIndicator)
        
        return vc
    } ()
    
    private init() { }
    
    static public let shared = LUIActivityIndicatorView()
    
    private let activityIndicator = UIActivityIndicatorView(style: .white)
    private let smallActivityIndicatorHeight: CGFloat = 32.0
    private var smallConstraints: [NSLayoutConstraint]?
    private var smallCenterConstraints: [NSLayoutConstraint]?
    
    private let largeActivityIndicatorHeight: CGFloat = 64.0
    private var largeConstraints: [NSLayoutConstraint]?
    private var largeCenterConstraints: [NSLayoutConstraint]?
    
    open func present(withStyle style: PresentationStyle, from vc: LUINavigation) {
        
        self.activityIndicator.startAnimating()
        self.activityIndicator.fadeIn()
        
        vc.popOver(self._wrapperVC)
        
        switch style {
            case .small:
                self.applySmallConstraint()
                self.activityIndicator.style = .white
                LUIPopOverViewController.current?.doesObscure = false
                break
            case .large:
                self.applyLargeConstraint()
                self.activityIndicator.style = .whiteLarge
                LUIPopOverViewController.current?.doesObscure = false
                break
            case .full:
                self.applyLargeConstraint()
                self.activityIndicator.style = .whiteLarge
                LUIPopOverViewController.current?.doesObscure = true
                break
        }
        
        self.activityIndicator.color = UIColor.color(for: .theme)
        LUIPopOverViewController.current?.isDismissible = false
    }
    
    open func dismiss() {
        LUIPopOverViewController.current?.isDismissible = true
        LUIPopOverViewController.current?.dismiss()
        self.activityIndicator.fadeOut {
            self.activityIndicator.stopAnimating()
        }
    }
    
    private func removeConstraints() {
        if let constraints = self.smallConstraints {
            for constraint in constraints {
                constraint.eliminate()
            }
        }
        
        if let constraints = self.largeConstraints {
            for constraint in constraints {
                constraint.eliminate()
            }
        }
        
        if let constraints = self.smallCenterConstraints {
            for constraint in constraints {
                constraint.eliminate()
            }
        }
        
        if let constraints = self.largeCenterConstraints {
            for constraint in constraints {
                constraint.eliminate()
            }
        }
    }
    
    private func applySmallConstraint() {
        self.removeConstraints()
        
        self.smallCenterConstraints = self._wrapperVC.view.center(self.activityIndicator)
        self.smallConstraints = self._wrapperVC.view.square(to: self.smallActivityIndicatorHeight)
        LUIPopOverViewController.current?.applyWidth(self.smallActivityIndicatorHeight)
    }
    
    private func applyLargeConstraint() {
        self.removeConstraints()
        
        self.largeCenterConstraints = self._wrapperVC.view.center(self.activityIndicator, offset: 1.5)
        self.largeConstraints = self._wrapperVC.view.square(to: self.largeActivityIndicatorHeight)
        LUIPopOverViewController.current?.applyWidth(self.largeActivityIndicatorHeight)
    }
}
