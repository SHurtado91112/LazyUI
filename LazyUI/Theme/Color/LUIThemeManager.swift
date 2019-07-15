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
                return self.themeColors.theme
            case .border:
                return self.themeColors.border
            case .shadow:
                return self.themeColors.shadow
            case .darkBackground:
                return self.themeColors.darkBackground
            case .lightBackground:
                return self.themeColors.lightBackground
            case .intermidiateBackground:
                return self.themeColors.intermediateBackground
            case .darkText:
                return self.themeColors.darkText
            case .lightText:
                return self.themeColors.lightText
            case .intermidiateText:
                return self.themeColors.intermediateText
            case .affirmation:
                return self.themeColors.affirmation
            case .negation:
                return self.themeColors.negation
        }
    }
    
    private func setTheme() {
        UIWindow.appearance().backgroundColor = self.themeColors.lightBackground
        LUIView.appearance().backgroundColor = self.themeColors.lightBackground
        LUITextField.appearance().textColor = self.themeColors.darkText
        
        // MARK: - NAVIGATION PROXY
        let navigationBar = UINavigationBar.appearance()
        navigationBar.tintColor = self.themeColors.theme
        navigationBar.barTintColor = self.themeColors.lightBackground
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : self.themeColors.darkText
        ]
        navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor : self.themeColors.darkText
        ]
        navigationBar.setBackgroundImage(nil, for: .default)
    }
}
