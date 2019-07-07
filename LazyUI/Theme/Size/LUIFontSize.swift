//
//  LUIFontSize.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/5/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import Foundation

public enum LUIFontSizeType {
    case title
    case large
    case regular
    case small
}

public enum LUIFontStyleType {
    case bold
    case italics
}

public struct LUIFontSize {
    
    public var title : CGFloat
    public var large : CGFloat
    public var regular : CGFloat
    public var small : CGFloat
    
    public init(title: CGFloat = 32.0, large: CGFloat = 24.0, regular: CGFloat = 16.0, small: CGFloat = 12.0) {
        self.title = title
        self.large = large
        self.regular = regular
        self.small = small
    }
    
    public func size(for type: LUIFontSizeType) -> CGFloat {
        switch type {
        case .title:
            return self.title
        case .large:
            return self.large
        case .regular:
            return self.regular
        case .small:
            return self.small
        }
    }
 
}
