//
//  TimeInterval+LUIAdditions.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/13/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import Foundation

extension TimeInterval {
    public static func timeInterval(for type: LUIAnimationSpeedType) -> TimeInterval {
        return LUIAnimationSpeedManager.shared.timeInterval(for: type)
    }
}
