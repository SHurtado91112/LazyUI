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
    
    func top(_ view: UIView, fromTop: Bool, paddingType: LUIPaddingType)
    func bottom(_ view: UIView, fromTop: Bool, paddingType: LUIPaddingType)
    
    func left(_ view: UIView, fromLeft: Bool, paddingType: LUIPaddingType)
    func right(_ view: UIView, fromLeft: Bool, paddingType: LUIPaddingType)
}
