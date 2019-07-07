//
//  LUIThemeManager.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/6/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import Foundation
import UIKit

public class LUIThemeManager: NSObject {
    private var themeColors : LUIColor!
    
    private override init() {
    }
    
    public static let shared = LUIThemeManager()
    
    public func setUniversalTheme(with colors: LUIColor) {
        self.themeColors = colors
        self.setTheme()
    }
    
    public func color(for type: LUIColorType) -> UIColor {
        switch type {
        case .theme:
            return themeColors.theme
        case .border:
            return themeColors.border
        case .shadow:
            return themeColors.shadow
        case .darkBackground:
            return themeColors.darkBackground
        case .lightBackground:
            return themeColors.lightBackground
        case .intermidiateBackground:
            return themeColors.intermediateBackground
        case .darkText:
            return themeColors.darkText
        case .lightText:
            return themeColors.lightText
        case .intermidiateText:
            return themeColors.intermediateText
        case .affirmation:
            return themeColors.affirmation
        case .negation:
            return themeColors.negation
        }
    }
    
    private func setTheme() {
        LUIView.appearance().backgroundColor = themeColors.lightBackground
    }
}
