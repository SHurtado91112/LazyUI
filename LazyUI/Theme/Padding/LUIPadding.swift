//
//  LUIPadding.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/9/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import Foundation

public enum LUIPaddingType {
    case large
    case regular
    case small
    case none
}

public struct LUIPadding {
    
    public var large : CGFloat
    public var regular : CGFloat
    public var small : CGFloat
    public var none : CGFloat = 0.0
    
    public init(large: CGFloat = 32.0, regular: CGFloat = 16.0, small: CGFloat = 8.0) {
        self.large = large
        self.regular = regular
        self.small = small
    }
    
    public func size(for type: LUIPaddingType) -> CGFloat {
        switch type {
        case .large:
            return self.large
        case .regular:
            return self.regular
        case .small:
            return self.small
        case .none:
            return self.none
        }
    }
    
    public static func padding(for type: LUIPaddingType) -> CGFloat {
        return LUIPaddingManager.shared.padding(for: type)
    }
    
    public static func paddingRect(for type: LUIPaddingType) -> UIEdgeInsets {
        return LUIPaddingManager.shared.paddingRect(for: type)
    }
    
}

