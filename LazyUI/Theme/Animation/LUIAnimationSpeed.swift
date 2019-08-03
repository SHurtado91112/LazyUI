//
//  LUIAnimation.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/13/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import Foundation

public enum LUIAnimationSpeedType {
    
    case slow
    case regular
    case fast
    case minimum
    case none
    
}

public struct LUIAnimationSpeed {
    
    public var slow : Double
    public var regular : Double
    public var fast : Double
    public var minimum : Double
    public var none : Double
    
    public init(slow: Double = 1.0, regular: Double = 0.5, fast: Double = 0.25, minimum: Double = 0.08) {
        self.slow = slow
        self.regular = regular
        self.fast = fast
        self.minimum = minimum
        self.none = 0.0
    }

    public static func timeInterval(for type: LUIAnimationSpeedType) -> TimeInterval {
        return LUIAnimationSpeedManager.shared.timeInterval(for: type)
    }
}
