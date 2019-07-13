//
//  LUIPaddingManager.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/12/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

public class LUIPaddingManager: NSObject {
    
    private var universalPadding : LUIPadding!
    
    private override init() {
    }
    
    public static let shared = LUIPaddingManager()
    
    public func setUniversalPadding(for padding: LUIPadding? = nil) {
        self.universalPadding = padding ?? LUIPadding()
        if let padding = padding {
            self.setPadding(padding)
        }
    }
    
    public func padding(for type: LUIPaddingType) -> CGFloat {
        switch type {
            case .large:
                return self.universalPadding.large
            case .regular:
                return self.universalPadding.regular
            case .small:
                return self.universalPadding.small
            case .none:
                return self.universalPadding.none
        }
    }
    
    public func paddingRect(for type: LUIPaddingType) -> UIEdgeInsets {
        var padding = self.universalPadding.none
        switch type {
            case .large:
                padding = self.universalPadding.large
                break
            case .regular:
                padding = self.universalPadding.regular
                break
            case .small:
                padding = self.universalPadding.small
                break
            case .none:
                break
        }
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
    
    private func setPadding(_ padding: LUIPadding) {
    }
}
