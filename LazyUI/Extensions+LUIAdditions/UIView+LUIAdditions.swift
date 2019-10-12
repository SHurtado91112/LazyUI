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
//        self.clipsToBounds = false
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
    
    func convertedFrame(fromSubview subview: UIView) -> CGRect? {
        // check if `subview` is a subview of self
        guard subview.isDescendant(of: self) else {
            return nil
        }
        
        var frame = subview.frame
        if subview.superview == nil {
            return frame
        }
        
        var superview = subview.superview
        while superview != self {
            frame = superview!.convert(frame, to: superview!.superview)
            if superview!.superview == nil {
                break
            } else {
                superview = superview!.superview
            }
        }
        
        return superview!.convert(frame, to: self)
    }
}

extension UIView: LUIConstraints {
    
    @discardableResult public func centerX(_ view: UIView) -> NSLayoutConstraint {
        return self.centerX(view, offset: 0.0)
    }
    
    @discardableResult public func centerY(_ view: UIView) -> NSLayoutConstraint {
        return self.centerY(view, offset: 0.0)
    }
    
    @discardableResult public func center(_ view: UIView) -> [NSLayoutConstraint] {
        return [self.centerX(view), self.centerY(view)]
    }
    
    
    @discardableResult public func centerX(_ view: UIView, offset: CGFloat) -> NSLayoutConstraint {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = view.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: offset)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult public func centerY(_ view: UIView, offset: CGFloat) -> NSLayoutConstraint {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = view.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: offset)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult public func center(_ view: UIView, offset: CGFloat) -> [NSLayoutConstraint] {
        return [self.centerX(view, offset: offset), self.centerY(view, offset: offset)]
    }
    
    @discardableResult public func fill(_ view: UIView, padding: LUIPaddingType, withSafety: Bool = false) -> [NSLayoutConstraint] {
        return [
            self.top(view, fromTop: true, paddingType: padding, withSafety: withSafety),
            self.bottom(view, fromTop: false, paddingType: padding, withSafety: withSafety),
            self.left(view, fromLeft: true, paddingType: padding, withSafety: withSafety),
            self.right(view, fromLeft: false, paddingType: padding, withSafety: withSafety),
        ]
    }
    
    @discardableResult public func top(_ view: UIView, fromTop: Bool, paddingType: LUIPaddingType, withSafety: Bool) -> NSLayoutConstraint {
        return self.top(view, fromTop: fromTop, paddingType: paddingType, withSafety: withSafety, constraintOperator: .equal)
    }
    @discardableResult public func top(_ view: UIView, fromTop: Bool, paddingType: LUIPaddingType, withSafety: Bool, constraintOperator: LUIConstraintOperator) -> NSLayoutConstraint {
        let padding = LUIPaddingManager.shared.padding(for: paddingType)
        let anchor = withSafety ? self.safeAreaLayoutGuide.topAnchor : self.topAnchor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        var constraint: NSLayoutConstraint!
        
        switch constraintOperator {
            case .equal:
                if fromTop {
                    constraint = view.topAnchor.constraint(equalTo: anchor, constant: padding)
                } else {
                    constraint = view.bottomAnchor.constraint(equalTo: anchor, constant: -padding)
                }
                break
            case .greaterThan:
                if fromTop {
                    constraint = view.topAnchor.constraint(greaterThanOrEqualTo: anchor, constant: padding)
                } else {
                    constraint = view.bottomAnchor.constraint(greaterThanOrEqualTo: anchor, constant: -padding)
                }
                break
            case .lessThan:
                if fromTop {
                    constraint = view.topAnchor.constraint(lessThanOrEqualTo: anchor, constant: padding)
                } else {
                    constraint = view.bottomAnchor.constraint(lessThanOrEqualTo: anchor, constant: -padding)
                }
                break
        }
        
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult public func bottom(_ view: UIView, fromTop: Bool, paddingType: LUIPaddingType, withSafety: Bool) -> NSLayoutConstraint {
        return self.bottom(view, fromTop: fromTop, paddingType: paddingType, withSafety: withSafety, constraintOperator: .equal)
    }
    @discardableResult public func bottom(_ view: UIView, fromTop: Bool, paddingType: LUIPaddingType, withSafety: Bool, constraintOperator: LUIConstraintOperator) -> NSLayoutConstraint {
        let padding = LUIPaddingManager.shared.padding(for: paddingType)
        let anchor = withSafety ? self.safeAreaLayoutGuide.bottomAnchor : self.bottomAnchor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        var constraint: NSLayoutConstraint!
        
        switch constraintOperator {
            case .equal:
                if fromTop {
                    constraint = view.topAnchor.constraint(equalTo: anchor, constant: padding)
                } else {
                    constraint = view.bottomAnchor.constraint(equalTo: anchor, constant: -padding)
                }
                break
            case .greaterThan:
                if fromTop {
                    constraint = view.topAnchor.constraint(greaterThanOrEqualTo: anchor, constant: padding)
                } else {
                    constraint = view.bottomAnchor.constraint(greaterThanOrEqualTo: anchor, constant: -padding)
                }
                break
            case .lessThan:
                if fromTop {
                    constraint = view.topAnchor.constraint(lessThanOrEqualTo: anchor, constant: padding)
                } else {
                    constraint = view.bottomAnchor.constraint(lessThanOrEqualTo: anchor, constant: -padding)
                }
                break
        }
        
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult public func left(_ view: UIView, fromLeft: Bool, paddingType: LUIPaddingType, withSafety: Bool) -> NSLayoutConstraint {
        return self.left(view, fromLeft: fromLeft, paddingType: paddingType, withSafety: withSafety, constraintOperator: .equal)
    }
    @discardableResult public func left(_ view: UIView, fromLeft: Bool, paddingType: LUIPaddingType, withSafety: Bool, constraintOperator: LUIConstraintOperator) -> NSLayoutConstraint {
        let padding = LUIPaddingManager.shared.padding(for: paddingType)
        let anchor = withSafety ? self.safeAreaLayoutGuide.leadingAnchor : self.leadingAnchor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        var constraint: NSLayoutConstraint!
        
        switch constraintOperator {
            case .equal:
                if fromLeft {
                    constraint = view.leadingAnchor.constraint(equalTo: anchor, constant: padding)
                } else {
                    constraint = view.trailingAnchor.constraint(equalTo: anchor, constant: -padding)
                }
                break
            case .greaterThan:
                if fromLeft {
                    constraint = view.leadingAnchor.constraint(greaterThanOrEqualTo: anchor, constant: padding)
                } else {
                    constraint = view.trailingAnchor.constraint(greaterThanOrEqualTo: anchor, constant: -padding)
                }
                break
            case .lessThan:
                if fromLeft {
                    constraint = view.leadingAnchor.constraint(lessThanOrEqualTo: anchor, constant: padding)
                } else {
                    constraint = view.trailingAnchor.constraint(lessThanOrEqualTo: anchor, constant: -padding)
                }
                break
        }
        
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult public func right(_ view: UIView, fromLeft: Bool, paddingType: LUIPaddingType, withSafety: Bool) -> NSLayoutConstraint {
        return self.right(view, fromLeft: fromLeft, paddingType: paddingType, withSafety: withSafety, constraintOperator: .equal)
    }
    @discardableResult public func right(_ view: UIView, fromLeft: Bool, paddingType: LUIPaddingType, withSafety: Bool, constraintOperator: LUIConstraintOperator) -> NSLayoutConstraint {
        let padding = LUIPaddingManager.shared.padding(for: paddingType)
        let anchor = withSafety ? self.safeAreaLayoutGuide.trailingAnchor : self.trailingAnchor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        var constraint: NSLayoutConstraint!
        
        switch constraintOperator {
            case .equal:
                if fromLeft {
                    constraint = view.leadingAnchor.constraint(equalTo: anchor, constant: padding)
                } else {
                    constraint = view.trailingAnchor.constraint(equalTo: anchor, constant: -padding)
                }
                break
            case .greaterThan:
                if fromLeft {
                    constraint = view.leadingAnchor.constraint(greaterThanOrEqualTo: anchor, constant: padding)
                } else {
                    constraint = view.trailingAnchor.constraint(greaterThanOrEqualTo: anchor, constant: -padding)
                }
                break
            case .lessThan:
                if fromLeft {
                    constraint = view.leadingAnchor.constraint(lessThanOrEqualTo: anchor, constant: padding)
                } else {
                    constraint = view.trailingAnchor.constraint(lessThanOrEqualTo: anchor, constant: -padding)
                }
                break
        }
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult public func width(to width: CGFloat) -> NSLayoutConstraint {
        return self.width(to: width, constraintOperator: .equal)
    }
    @discardableResult public func width(to width: CGFloat, constraintOperator: LUIConstraintOperator) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        var constraint: NSLayoutConstraint!
        
        switch constraintOperator {
            case .equal:
                constraint = self.widthAnchor.constraint(equalToConstant: width)
                break
            case .greaterThan:
                constraint = self.widthAnchor.constraint(greaterThanOrEqualToConstant: width)
                break
            case .lessThan:
                constraint = self.widthAnchor.constraint(lessThanOrEqualToConstant: width)
                break
        }
        constraint.isActive = true
        return constraint
    }
    @discardableResult public func width(to width: NSLayoutDimension, constraintOperator: LUIConstraintOperator) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        var constraint: NSLayoutConstraint!
        
        switch constraintOperator {
        case .equal:
            constraint = self.widthAnchor.constraint(equalTo: width)
            break
        case .greaterThan:
            constraint = self.widthAnchor.constraint(greaterThanOrEqualTo: width)
            break
        case .lessThan:
            constraint = self.widthAnchor.constraint(lessThanOrEqualTo: width)
            break
        }
        
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult public func height(to height: CGFloat) -> NSLayoutConstraint {
        return self.height(to: height, constraintOperator: .equal)
    }
    @discardableResult public func height(to height: CGFloat, constraintOperator: LUIConstraintOperator) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        var constraint: NSLayoutConstraint!
        
        switch constraintOperator {
        case .equal:
            constraint = self.heightAnchor.constraint(equalToConstant: height)
            break
        case .greaterThan:
            constraint = self.heightAnchor.constraint(greaterThanOrEqualToConstant: height)
            break
        case .lessThan:
            constraint = self.heightAnchor.constraint(lessThanOrEqualToConstant: height)
            break
        }
        constraint.isActive = true
        return constraint
    }
    @discardableResult public func height(to height: NSLayoutDimension, constraintOperator: LUIConstraintOperator) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        var constraint: NSLayoutConstraint!
        
        switch constraintOperator {
        case .equal:
            constraint = self.heightAnchor.constraint(equalTo: height)
            break
        case .greaterThan:
            constraint = self.heightAnchor.constraint(greaterThanOrEqualTo: height)
            break
        case .lessThan:
            constraint = self.heightAnchor.constraint(lessThanOrEqualTo: height)
            break
        }
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult public func square(to size: CGFloat) -> [NSLayoutConstraint] {
        self.roundCorners(to: 0.0) // undoes any changes to corners
        return [self.width(to: size, constraintOperator: .equal), self.height(to: size, constraintOperator: .equal)]
    }
    
    @discardableResult public func circle(to size: CGFloat) -> [NSLayoutConstraint] {
        let constraints = self.square(to: size)
        self.roundCorners(to: size/2.0)
        return constraints
    }
    
    @discardableResult public func aspectRatio(_ ratio: LUIAspectRatio) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = self.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: CGFloat(ratio.value))
        constraint.isActive = true
        return constraint
    }
}
