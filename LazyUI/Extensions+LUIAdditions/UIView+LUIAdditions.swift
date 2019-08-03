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
        UIView.animate(withDuration: TimeInterval.timeInterval(for: .fast), delay: 0.0, options: .curveEaseIn, animations: {
            self.alpha = 1.0
        }) { (done) in
            finished?()
        }
    }
    
    public func fadeOut(_ finished: (()->Void)? = nil) {
        UIView.animate(withDuration: TimeInterval.timeInterval(for: .fast), delay: 0.0, options: .curveEaseOut, animations: {
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
    
    public func fill(_ view: UIView, padding: LUIPaddingType, withSafety: Bool = false) {
        self.top(view, fromTop: true, paddingType: padding, withSafety: withSafety)
        self.bottom(view, fromTop: false, paddingType: padding, withSafety: withSafety)
        self.left(view, fromLeft: true, paddingType: padding, withSafety: withSafety)
        self.right(view, fromLeft: false, paddingType: padding, withSafety: withSafety)
    }
    
    public func top(_ view: UIView, fromTop: Bool, paddingType: LUIPaddingType, withSafety: Bool) {
        self.top(view, fromTop: fromTop, paddingType: paddingType, withSafety: withSafety, constraintOperator: .equal)
    }
    public func top(_ view: UIView, fromTop: Bool, paddingType: LUIPaddingType, withSafety: Bool, constraintOperator: LUIConstraintOperator) {
        let padding = LUIPaddingManager.shared.padding(for: paddingType)
        let anchor = withSafety ? self.safeAreaLayoutGuide.topAnchor : self.topAnchor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        switch constraintOperator {
            case .equal:
                if fromTop {
                    view.topAnchor.constraint(equalTo: anchor, constant: padding).isActive = true
                } else {
                    view.bottomAnchor.constraint(equalTo: anchor, constant: -padding).isActive = true
                }
                break
            case .greaterThan:
                if fromTop {
                    view.topAnchor.constraint(greaterThanOrEqualTo: anchor, constant: padding).isActive = true
                } else {
                    view.bottomAnchor.constraint(greaterThanOrEqualTo: anchor, constant: -padding).isActive = true
                }
                break
            case .lessThan:
                if fromTop {
                    view.topAnchor.constraint(lessThanOrEqualTo: anchor, constant: padding).isActive = true
                } else {
                    view.bottomAnchor.constraint(lessThanOrEqualTo: anchor, constant: -padding).isActive = true
                }
                break
        }
    }
    
    public func bottom(_ view: UIView, fromTop: Bool, paddingType: LUIPaddingType, withSafety: Bool) {
        self.bottom(view, fromTop: fromTop, paddingType: paddingType, withSafety: withSafety, constraintOperator: .equal)
    }
    public func bottom(_ view: UIView, fromTop: Bool, paddingType: LUIPaddingType, withSafety: Bool, constraintOperator: LUIConstraintOperator) {
        let padding = LUIPaddingManager.shared.padding(for: paddingType)
        let anchor = withSafety ? self.safeAreaLayoutGuide.bottomAnchor : self.bottomAnchor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        switch constraintOperator {
            case .equal:
                if fromTop {
                    view.topAnchor.constraint(equalTo: anchor, constant: padding).isActive = true
                } else {
                    view.bottomAnchor.constraint(equalTo: anchor, constant: -padding).isActive = true
                }
                break
            case .greaterThan:
                if fromTop {
                    view.topAnchor.constraint(greaterThanOrEqualTo: anchor, constant: padding).isActive = true
                } else {
                    view.bottomAnchor.constraint(greaterThanOrEqualTo: anchor, constant: -padding).isActive = true
                }
                break
            case .lessThan:
                if fromTop {
                    view.topAnchor.constraint(lessThanOrEqualTo: anchor, constant: padding).isActive = true
                } else {
                    view.bottomAnchor.constraint(lessThanOrEqualTo: anchor, constant: -padding).isActive = true
                }
                break
        }
    }
    
    public func left(_ view: UIView, fromLeft: Bool, paddingType: LUIPaddingType, withSafety: Bool) {
        self.left(view, fromLeft: fromLeft, paddingType: paddingType, withSafety: withSafety, constraintOperator: .equal)
    }
    public func left(_ view: UIView, fromLeft: Bool, paddingType: LUIPaddingType, withSafety: Bool, constraintOperator: LUIConstraintOperator) {
        let padding = LUIPaddingManager.shared.padding(for: paddingType)
        let anchor = withSafety ? self.safeAreaLayoutGuide.leadingAnchor : self.leadingAnchor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        switch constraintOperator {
            case .equal:
                if fromLeft {
                    view.leadingAnchor.constraint(equalTo: anchor, constant: padding).isActive = true
                } else {
                    view.trailingAnchor.constraint(equalTo: anchor, constant: -padding).isActive = true
                }
                break
            case .greaterThan:
                if fromLeft {
                    view.leadingAnchor.constraint(greaterThanOrEqualTo: anchor, constant: padding).isActive = true
                } else {
                    view.trailingAnchor.constraint(greaterThanOrEqualTo: anchor, constant: -padding).isActive = true
                }
                break
            case .lessThan:
                if fromLeft {
                    view.leadingAnchor.constraint(lessThanOrEqualTo: anchor, constant: padding).isActive = true
                } else {
                    view.trailingAnchor.constraint(lessThanOrEqualTo: anchor, constant: -padding).isActive = true
                }
                break
        }
    }
    
    public func right(_ view: UIView, fromLeft: Bool, paddingType: LUIPaddingType, withSafety: Bool) {
        self.right(view, fromLeft: fromLeft, paddingType: paddingType, withSafety: withSafety, constraintOperator: .equal)
    }
    public func right(_ view: UIView, fromLeft: Bool, paddingType: LUIPaddingType, withSafety: Bool, constraintOperator: LUIConstraintOperator) {
        let padding = LUIPaddingManager.shared.padding(for: paddingType)
        let anchor = withSafety ? self.safeAreaLayoutGuide.trailingAnchor : self.trailingAnchor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        switch constraintOperator {
            case .equal:
                if fromLeft {
                    view.leadingAnchor.constraint(equalTo: anchor, constant: padding).isActive = true
                } else {
                    view.trailingAnchor.constraint(equalTo: anchor, constant: -padding).isActive = true
                }
                break
            case .greaterThan:
                if fromLeft {
                    view.leadingAnchor.constraint(greaterThanOrEqualTo: anchor, constant: padding).isActive = true
                } else {
                    view.trailingAnchor.constraint(greaterThanOrEqualTo: anchor, constant: -padding).isActive = true
                }
                break
            case .lessThan:
                if fromLeft {
                    view.leadingAnchor.constraint(lessThanOrEqualTo: anchor, constant: padding).isActive = true
                } else {
                    view.trailingAnchor.constraint(lessThanOrEqualTo: anchor, constant: -padding).isActive = true
                }
                break
        }
    }
    
    public func width(to width: CGFloat) {
        self.width(to: width, constraintOperator: .equal)
    }
    public func width(to width: CGFloat, constraintOperator: LUIConstraintOperator) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        switch constraintOperator {
            case .equal:
                self.widthAnchor.constraint(equalToConstant: width).isActive = true
                break
            case .greaterThan:
                self.widthAnchor.constraint(greaterThanOrEqualToConstant: width).isActive = true
                break
            case .lessThan:
                self.widthAnchor.constraint(lessThanOrEqualToConstant: width).isActive = true
                break
        }
    }
    public func width(to width: NSLayoutDimension, constraintOperator: LUIConstraintOperator) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        switch constraintOperator {
        case .equal:
            self.widthAnchor.constraint(equalTo: width).isActive = true
            break
        case .greaterThan:
            self.widthAnchor.constraint(greaterThanOrEqualTo: width).isActive = true
            break
        case .lessThan:
            self.widthAnchor.constraint(lessThanOrEqualTo: width).isActive = true
            break
        }
        
    }
    
    public func height(to height: CGFloat) {
        self.height(to: height, constraintOperator: .equal)
    }
    public func height(to height: CGFloat, constraintOperator: LUIConstraintOperator) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        switch constraintOperator {
        case .equal:
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
            break
        case .greaterThan:
            self.heightAnchor.constraint(greaterThanOrEqualToConstant: height).isActive = true
            break
        case .lessThan:
            self.heightAnchor.constraint(lessThanOrEqualToConstant: height).isActive = true
            break
        }
        
    }
    public func height(to height: NSLayoutDimension, constraintOperator: LUIConstraintOperator) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        switch constraintOperator {
        case .equal:
            self.heightAnchor.constraint(equalTo: height).isActive = true
            break
        case .greaterThan:
            self.heightAnchor.constraint(greaterThanOrEqualTo: height).isActive = true
            break
        case .lessThan:
            self.heightAnchor.constraint(lessThanOrEqualTo: height).isActive = true
            break
        }
        
    }
    
    public func square(to size: CGFloat) {
        self.width(to: size, constraintOperator: .equal)
        self.height(to: size, constraintOperator: .equal)
    }
    
    public func circle(to size: CGFloat) {
        self.square(to: size)
        self.roundCorners(to: size/2.0)
    }
    
    public func aspectRatio(_ ratio: LUIAspectRatio) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: CGFloat(ratio.value)).isActive = true
    }
}
