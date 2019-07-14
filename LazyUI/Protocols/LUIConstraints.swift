//
//  LUIConstraints.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/7/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import Foundation

public protocol LUIConstraints {
    func centerX(_ view: UIView)
    func centerY(_ view: UIView)
    func center(_ view: UIView)
    func fill(_ view: UIView, padding: LUIPaddingType)
    
    func top(_ view: UIView, fromTop: Bool, paddingType: LUIPaddingType, withSafety: Bool)
    func bottom(_ view: UIView, fromTop: Bool, paddingType: LUIPaddingType, withSafety: Bool)
    
    func left(_ view: UIView, fromLeft: Bool, paddingType: LUIPaddingType, withSafety: Bool)
    func right(_ view: UIView, fromLeft: Bool, paddingType: LUIPaddingType, withSafety: Bool)
    
    func width(to width: CGFloat)
    func height(to height: CGFloat)
    func square(to size: CGFloat)
    func circle(to size: CGFloat)
}
