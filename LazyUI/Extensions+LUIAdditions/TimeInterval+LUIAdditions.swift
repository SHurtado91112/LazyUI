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
    
    public static func from(days: Double = 0.0, hours: Double = 0.0, minutes: Double = 0.0, seconds: Double = 0.0) -> TimeInterval {
        
        var totalSeconds = seconds
        totalSeconds = totalSeconds + (minutes * 60.0)
        totalSeconds = totalSeconds + (hours * 60.0 * 60.0)
        totalSeconds = totalSeconds + (days * 24.0 * 60.0 * 60.0)
        
        return totalSeconds
    }
}
