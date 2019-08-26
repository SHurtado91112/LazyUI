//
//  TimeInterval+LUIAdditions.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/13/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import Foundation

extension TimeInterval {
    
    public var miliseconds: Int {
        let intervalInSeconds = self
        return Int(intervalInSeconds * 1000.0)
    }
    
    public static func timeInterval(for type: LUIAnimationSpeedType) -> TimeInterval {
        return LUIAnimationSpeedManager.shared.timeInterval(for: type)
    }
}
