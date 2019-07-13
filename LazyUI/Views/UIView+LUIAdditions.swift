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
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.color(for: .shadow).cgColor
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 4
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    public func roundCorners(to radius: CGFloat) {
        self.layer.cornerRadius = radius
//        self.clipsToBounds = true
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
        centerX(view)
        centerY(view)
    }
    
    public func top(_ view: UIView, fromTop: Bool, paddingType: LUIPaddingType) {
        let padding = LUIPaddingManager.shared.padding(for: paddingType)
        view.translatesAutoresizingMaskIntoConstraints = false
        if fromTop {
            view.topAnchor.constraint(equalTo: self.topAnchor, constant: padding).isActive = true
        } else {
            view.bottomAnchor.constraint(equalTo: self.topAnchor, constant: -padding).isActive = true
        }
    }
    
    public func bottom(_ view: UIView, fromTop: Bool, paddingType: LUIPaddingType) {
        let padding = LUIPaddingManager.shared.padding(for: paddingType)
        view.translatesAutoresizingMaskIntoConstraints = false
        if fromTop {
            view.topAnchor.constraint(equalTo: self.bottomAnchor, constant: padding).isActive = true
        } else {
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding).isActive = true
        }
    }
    
    public func left(_ view: UIView, fromLeft: Bool, paddingType: LUIPaddingType) {
        let padding = LUIPaddingManager.shared.padding(for: paddingType)
        view.translatesAutoresizingMaskIntoConstraints = false
        if fromLeft {
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding).isActive = true
        } else {
            view.trailingAnchor.constraint(equalTo: self.leadingAnchor, constant: -padding).isActive = true
        }
    }
    
    public func right(_ view: UIView, fromLeft: Bool, paddingType: LUIPaddingType) {
        let padding = LUIPaddingManager.shared.padding(for: paddingType)
        view.translatesAutoresizingMaskIntoConstraints = false
        if fromLeft {
            view.leadingAnchor.constraint(equalTo: self.trailingAnchor, constant: padding).isActive = true
        } else {
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding).isActive = true
        }
    }
}
