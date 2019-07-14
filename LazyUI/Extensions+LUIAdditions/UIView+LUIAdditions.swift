//
//  UIView+LUIAdditions.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/7/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    public func addShadow() {
        self.layer.shadowColor = UIColor.color(for: .shadow).cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 3.0
    }
    
    public func roundCorners(to radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = false
    }
    
    public func fadeInOut(_ finished: (()->Void)? = nil) {
        self.fadeIn {
            self.fadeOut({
                finished?()
            })
        }
    }
    
    public func fadeIn(_ finished: (()->Void)? = nil) {
        UIView.animate(withDuration: TimeInterval.timeInterval(for: .fast), animations: {
            self.alpha = 1.0
        }) { (done) in
            finished?()
        }
    }
    
    public func fadeOut(_ finished: (()->Void)? = nil) {
        UIView.animate(withDuration: TimeInterval.timeInterval(for: .fast), animations: {
            self.alpha = 0.0
        }) { (done) in
            finished?()
        }
    }
    
}

extension UIView: LUIConstraints {
    
    public func centerX(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    public func centerY(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    public func center(_ view: UIView) {
        self.centerX(view)
        self.centerY(view)
    }
    
    public func fill(_ view: UIView, padding: LUIPaddingType) {
        self.top(view, fromTop: true, paddingType: padding, withSafety: false)
        self.bottom(view, fromTop: false, paddingType: padding, withSafety: false)
        self.left(view, fromLeft: true, paddingType: padding, withSafety: false)
        self.right(view, fromLeft: false, paddingType: padding, withSafety: false)
    }
    
    public func top(_ view: UIView, fromTop: Bool, paddingType: LUIPaddingType, withSafety: Bool) {
        let padding = LUIPaddingManager.shared.padding(for: paddingType)
        let anchor = withSafety ? self.safeAreaLayoutGuide.topAnchor : self.topAnchor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if fromTop {
            view.topAnchor.constraint(equalTo: anchor, constant: padding).isActive = true
        } else {
            view.bottomAnchor.constraint(equalTo: anchor, constant: -padding).isActive = true
        }
    }
    
    public func bottom(_ view: UIView, fromTop: Bool, paddingType: LUIPaddingType, withSafety: Bool) {
        let padding = LUIPaddingManager.shared.padding(for: paddingType)
        let anchor = withSafety ? self.safeAreaLayoutGuide.bottomAnchor : self.bottomAnchor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if fromTop {
            view.topAnchor.constraint(equalTo: anchor, constant: padding).isActive = true
        } else {
            view.bottomAnchor.constraint(equalTo: anchor, constant: -padding).isActive = true
        }
    }
    
    public func left(_ view: UIView, fromLeft: Bool, paddingType: LUIPaddingType, withSafety: Bool) {
        let padding = LUIPaddingManager.shared.padding(for: paddingType)
        let anchor = withSafety ? self.safeAreaLayoutGuide.leadingAnchor : self.leadingAnchor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if fromLeft {
            view.leadingAnchor.constraint(equalTo: anchor, constant: padding).isActive = true
        } else {
            view.trailingAnchor.constraint(equalTo: anchor, constant: -padding).isActive = true
        }
    }
    
    public func right(_ view: UIView, fromLeft: Bool, paddingType: LUIPaddingType, withSafety: Bool) {
        let padding = LUIPaddingManager.shared.padding(for: paddingType)
        let anchor = withSafety ? self.safeAreaLayoutGuide.trailingAnchor : self.trailingAnchor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if fromLeft {
            view.leadingAnchor.constraint(equalTo: anchor, constant: padding).isActive = true
        } else {
            view.trailingAnchor.constraint(equalTo: anchor, constant: -padding).isActive = true
        }
    }
    
    public func width(to width: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    public func height(to height: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    public func square(to size: CGFloat) {
        self.width(to: size)
        self.height(to: size)
    }
    
    public func circle(to size: CGFloat) {
        self.square(to: size)
        self.roundCorners(to: size/2.0)
    }
}
