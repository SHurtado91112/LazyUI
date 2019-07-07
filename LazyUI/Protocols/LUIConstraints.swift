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
    
    func top(_ view: UIView, fromTop: Bool, spacing: CGFloat)
    func bottom(_ view: UIView, fromTop: Bool, spacing: CGFloat)
    
    func left(_ view: UIView, fromLeft: Bool, spacing: CGFloat)
    func right(_ view: UIView, fromLeft: Bool, spacing: CGFloat)
}
