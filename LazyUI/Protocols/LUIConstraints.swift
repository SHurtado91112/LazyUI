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

public protocol LUIConstraints {
    func centerX(_ view: UIView)
    func centerY(_ view: UIView)
    func center(_ view: UIView)
    func fill(_ view: UIView, padding: LUIPaddingType, withSafety: Bool)
    
    func top(_ view: UIView, fromTop: Bool, paddingType: LUIPaddingType, withSafety: Bool, constraintOperator: LUIConstraintOperator)
    func bottom(_ view: UIView, fromTop: Bool, paddingType: LUIPaddingType, withSafety: Bool, constraintOperator: LUIConstraintOperator)
    
    func left(_ view: UIView, fromLeft: Bool, paddingType: LUIPaddingType, withSafety: Bool, constraintOperator: LUIConstraintOperator)
    func right(_ view: UIView, fromLeft: Bool, paddingType: LUIPaddingType, withSafety: Bool, constraintOperator: LUIConstraintOperator)
    
    func width(to width: CGFloat, constraintOperator: LUIConstraintOperator)
    func width(to width: NSLayoutDimension, constraintOperator: LUIConstraintOperator)
    
    func height(to height: CGFloat, constraintOperator: LUIConstraintOperator)
    func height(to height: NSLayoutDimension, constraintOperator: LUIConstraintOperator)
    
    func square(to size: CGFloat)
    func circle(to size: CGFloat)
    func aspectRatio(_ ratio: LUIAspectRatio)
}
