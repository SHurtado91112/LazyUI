//
//  UIView+LUIAdditions.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/7/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import Foundation
import UIKit

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
        centerX(view)
        centerY(view)
    }
    
    public func top(_ view: UIView, fromTop: Bool, spacing: CGFloat) {
        view.translatesAutoresizingMaskIntoConstraints = false
        if fromTop {
            view.topAnchor.constraint(equalTo: self.topAnchor, constant: spacing).isActive = true
        } else {
            view.bottomAnchor.constraint(equalTo: self.topAnchor, constant: -spacing).isActive = true
        }
    }
    
    public func bottom(_ view: UIView, fromTop: Bool, spacing: CGFloat) {
        view.translatesAutoresizingMaskIntoConstraints = false
        if fromTop {
            view.topAnchor.constraint(equalTo: self.bottomAnchor, constant: spacing).isActive = true
        } else {
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -spacing).isActive = true
        }
    }
    
    public func left(_ view: UIView, fromLeft: Bool, spacing: CGFloat) {
        view.translatesAutoresizingMaskIntoConstraints = false
        if fromLeft {
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spacing).isActive = true
        } else {
            view.trailingAnchor.constraint(equalTo: self.leadingAnchor, constant: -spacing).isActive = true
        }
    }
    
    public func right(_ view: UIView, fromLeft: Bool, spacing: CGFloat) {
        view.translatesAutoresizingMaskIntoConstraints = false
        if fromLeft {
            view.leadingAnchor.constraint(equalTo: self.trailingAnchor, constant: spacing).isActive = true
        } else {
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -spacing).isActive = true
        }
    }
}
