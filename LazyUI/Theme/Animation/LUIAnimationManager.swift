//
//  LUIAnimationManager.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/13/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import Foundation
import UIKit

public class LUIAnimationSpeedManager: NSObject {
    
    private var animationSpeeds : LUIAnimationSpeed!
    
    private override init() {
    }
    
    public static let shared = LUIAnimationSpeedManager()
    
    public func setUniversalAnimationSpeed(with animationSpeeds: LUIAnimationSpeed) {
        self.animationSpeeds = animationSpeeds
    }
    
    public func timeInterval(for type: LUIAnimationSpeedType) -> TimeInterval {
        switch type {
            case .slow:
                return self.animationSpeeds.slow
            case .regular:
                return self.animationSpeeds.regular
            case .fast:
                return self.animationSpeeds.fast
            case .minimum:
                return self.animationSpeeds.minimum
            case .none:
                return self.animationSpeeds.none
        }
    }
}
