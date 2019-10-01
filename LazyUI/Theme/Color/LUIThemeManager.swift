//
//  LUIThemeManager.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/6/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import Foundation
import UIKit

internal let LUIThemeUpdateNotification = Notification.Name(rawValue: "lazy_ui_theme_updated")

internal protocol LUIThemeProtocol {
    func themeUpdated()
    func registerForThemeObserver()
    func unregisterForThemeObserver()
}

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
        return self.themeColors.color(for: type)
    }
    
    public func type(for color: UIColor) -> LUIColorType {
        return self.themeColors.type(for: color)
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
        
        // MARK: - SEARCH PROXY
        let searchBar = UISearchBar.appearance()
        searchBar.tintColor = self.themeColors.theme
        searchBar.barTintColor = self.themeColors.intermediateBackground
        
        // Set off observer for theme update
        NotificationCenter.default.post(name: LUIThemeUpdateNotification, object: nil)
    }
}
