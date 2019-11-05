//
//  LUIActivityIndicatorView.swift
//  LazyUI
//
//  Created by Steven Hurtado on 10/11/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

fileprivate let DEFAULT_TIME_OUT: TimeInterval = 10.0

open class LUIActivityIndicatorView {
    
    public enum PresentationStyle {
        case small
        case large
        case full
    }
    
    
    open var timeOut: TimeInterval = DEFAULT_TIME_OUT
    
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
    
    private var lastStyle: PresentationStyle = .small
    private var persistCounter: [String: Int] = [:]
    private var timeOutTimer: Timer?
    
    open func present(withStyle style: PresentationStyle, from vc: LUINavigation, withIdentifier identifier: String = "") {
        
        self.activityIndicator.startAnimating()
        self.activityIndicator.fadeIn()
        
        vc.popOver(self._wrapperVC)
        self.applyStyle(style)

        self.lastStyle = style

        if !identifier.isEmpty {
            if var counter = self.persistCounter[identifier] {
                counter += 1
                print("PERSISTING: \(identifier), count: \(counter)")
                self.persistCounter[identifier] = counter
            } else {
                self.persistCounter[identifier] = 0
                print("START PERSIST: \(identifier)")
            }
        }

        self.configureTimer()
    }
    
    open func persist(for identifier: String) {

        if !self.activityIndicator.isAnimating {
            self.activityIndicator.startAnimating()
            self.activityIndicator.fadeIn()
        }
        
        self.applyStyle(self.lastStyle)
        
        if var counter = self.persistCounter[identifier] {
            counter -= 1
            print("DIMINISHING PERSIST: \(identifier), count: \(counter)")
            self.persistCounter[identifier] = counter
            if counter <= 0 {
                print("FINISHED PERSISTING: \(identifier)")
                self.persistCounter.removeValue(forKey: identifier)
                
                if self.persistCounter.count == 0 {
                    print("FINISH TOTAL PERSIST")
                    self.dismiss()
                }
                
            }
        }
        
        self.configureTimer()
    }
    
    open func dismiss() {
        self.persistCounter = [:]
        LUIPopOverViewController.current?.isDismissible = true
        LUIPopOverViewController.current?.dismiss()
        self.activityIndicator.fadeOut {
            self.activityIndicator.stopAnimating()
        }
    }
    
    private func configureTimer() {
        self.timeOutTimer?.invalidate()
        self.timeOutTimer = Timer.scheduledTimer(withTimeInterval: self.timeOut, repeats: false, block: { (Timer) in
            
            if self.activityIndicator.isAnimating {
                print("Activity indicator invalidated")
                self.dismiss()
            }
            
        })
    }
    
    private func applyStyle(_ style: PresentationStyle) {
        
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
        
        if let superView = self.activityIndicator.superview {
            superView.bringSubviewToFront(self.activityIndicator)
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
