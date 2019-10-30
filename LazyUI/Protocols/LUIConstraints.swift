//
//  LUIConstraints.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/7/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import Foundation

public enum LUIConstraintOperator {
    case equal
    case lessThan
    case greaterThan
}

extension NSLayoutConstraint {
    open func eliminate() {
        self.firstItem?.removeConstraint(self)
        self.secondItem?.removeConstraint(self)
    }
}

public protocol LUIConstraints {
    func centerX(_ view: UIView) -> NSLayoutConstraint
    func centerY(_ view: UIView) -> NSLayoutConstraint
    func center(_ view: UIView) -> [NSLayoutConstraint]
    
    func centerX(_ view: UIView, offset: CGFloat) -> NSLayoutConstraint
    func centerY(_ view: UIView, offset: CGFloat) -> NSLayoutConstraint
    func center(_ view: UIView, offset: CGFloat) -> [NSLayoutConstraint]
    
    func fill(_ view: UIView, padding: LUIPaddingType, withSafety: Bool) -> [NSLayoutConstraint]
    
    func top(_ view: UIView, fromTop: Bool, paddingType: LUIPaddingType, withSafety: Bool, constraintOperator: LUIConstraintOperator) -> NSLayoutConstraint
    func bottom(_ view: UIView, fromTop: Bool, paddingType: LUIPaddingType, withSafety: Bool, constraintOperator: LUIConstraintOperator) -> NSLayoutConstraint
    
    func left(_ view: UIView, fromLeft: Bool, paddingType: LUIPaddingType, withSafety: Bool, constraintOperator: LUIConstraintOperator) -> NSLayoutConstraint
    func right(_ view: UIView, fromLeft: Bool, paddingType: LUIPaddingType, withSafety: Bool, constraintOperator: LUIConstraintOperator) -> NSLayoutConstraint
    
    // with custom padding value
    func top(_ view: UIView, fromTop: Bool, padding: CGFloat, withSafety: Bool, constraintOperator: LUIConstraintOperator) -> NSLayoutConstraint
    func bottom(_ view: UIView, fromTop: Bool, padding: CGFloat, withSafety: Bool, constraintOperator: LUIConstraintOperator) -> NSLayoutConstraint
    
    func left(_ view: UIView, fromLeft: Bool, padding: CGFloat, withSafety: Bool, constraintOperator: LUIConstraintOperator) -> NSLayoutConstraint
    func right(_ view: UIView, fromLeft: Bool, padding: CGFloat, withSafety: Bool, constraintOperator: LUIConstraintOperator) -> NSLayoutConstraint
    
    func width(to width: CGFloat, constraintOperator: LUIConstraintOperator) -> NSLayoutConstraint
    func width(to width: NSLayoutDimension, constraintOperator: LUIConstraintOperator) -> NSLayoutConstraint
    
    func height(to height: CGFloat, constraintOperator: LUIConstraintOperator) -> NSLayoutConstraint
    func height(to height: NSLayoutDimension, constraintOperator: LUIConstraintOperator) -> NSLayoutConstraint
    
    func square(to size: CGFloat) -> [NSLayoutConstraint]
    func circle(to size: CGFloat) -> [NSLayoutConstraint]
    func aspectRatio(_ ratio: LUIAspectRatio) -> NSLayoutConstraint
}
