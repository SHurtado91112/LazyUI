//
//  LUIColor.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/6/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import Foundation
import UIKit

public enum LUIColorType: CaseIterable {
    
    case theme
    case border
    case shadow
    
    case darkBackground
    case lightBackground
    case intermediateBackground
    
    case darkText
    case lightText
    case intermediateText
    
    case affirmation
    case negation

    case empty
}


public struct LUIColor {
    
    public static var defaultTheme = LUIColor(theme: UIColor.blue, border: UIColor.gray, shadow: UIColor.black.withAlphaComponent(0.6), darkBackground: UIColor.darkGray, lightBackground: UIColor.white, intermediateBackground: UIColor.lightGray, darkText: UIColor.darkText, lightText: UIColor.white, intermediateText: UIColor.lightGray, affirmation: UIColor(hexString: "#34C759"), negation: UIColor.red)
    
    public static var darkTheme = LUIColor(theme: UIColor.orange, border: UIColor.lightGray, shadow: UIColor.lightGray.withAlphaComponent(0.6), darkBackground: UIColor.white, lightBackground: UIColor.darkGray, intermediateBackground: UIColor.lightGray, darkText: UIColor.white, lightText: UIColor.darkText, intermediateText: UIColor.lightGray, affirmation: UIColor(hexString: "#34C759"), negation: UIColor.red)
    
    public var theme : UIColor
    public var border : UIColor
    public var shadow : UIColor
    
    public var darkBackground : UIColor
    public var lightBackground : UIColor
    public var intermediateBackground : UIColor
    
    public var darkText : UIColor
    public var lightText : UIColor
    public var intermediateText : UIColor
    
    public var affirmation : UIColor
    public var negation : UIColor
    
    public init(theme: UIColor = LUIColor.defaultTheme.theme, border: UIColor = LUIColor.defaultTheme.border,
                shadow: UIColor = LUIColor.defaultTheme.shadow, darkBackground: UIColor = LUIColor.defaultTheme.darkBackground,
                lightBackground: UIColor = LUIColor.defaultTheme.lightBackground, intermediateBackground: UIColor = LUIColor.defaultTheme.intermediateBackground,
                darkText: UIColor = LUIColor.defaultTheme.darkText, lightText: UIColor = LUIColor.defaultTheme.lightText,
                intermediateText: UIColor = LUIColor.defaultTheme.intermediateText, affirmation: UIColor = LUIColor.defaultTheme.affirmation, negation: UIColor = LUIColor.defaultTheme.negation) {
        self.theme = theme
        self.border = border
        self.shadow = shadow
        self.darkBackground = darkBackground
        self.lightBackground = lightBackground
        self.intermediateBackground = intermediateBackground
        self.darkText = darkText
        self.lightText = lightText
        self.intermediateText = intermediateText
        self.affirmation = affirmation
        self.negation = negation
    }

    public var colors: [UIColor] {
        var colors: [UIColor] = []
        LUIColorType.allCases.forEach { (type) in
            switch type {
                case .theme:
                    colors.append(self.theme)
                    break
                case .border:
                    colors.append(self.border)
                    break
                case .shadow:
                    colors.append(self.shadow)
                    break
                case .darkBackground:
                    colors.append(self.darkBackground)
                    break
                case .lightBackground:
                    colors.append(self.lightBackground)
                    break
                case .intermediateBackground:
                    colors.append(self.intermediateBackground)
                    break
                case .darkText:
                    colors.append(self.darkText)
                    break
                case .lightText:
                    colors.append(self.lightText)
                    break
                case .intermediateText:
                    colors.append(self.intermediateText)
                    break
                case .affirmation:
                    colors.append(self.affirmation)
                    break
                case .negation:
                    colors.append(self.negation)
                    break
                case .empty:
                    colors.append(.clear)
                    break
            }
        }
        return colors
    }
    
    public func color(for type: LUIColorType) -> UIColor {
        switch type {
        case .theme:
            return self.theme
        case .border:
            return self.border
        case .shadow:
            return self.shadow
        case .darkBackground:
            return self.darkBackground
        case .lightBackground:
            return self.lightBackground
        case .intermediateBackground:
            return self.intermediateBackground
        case .darkText:
            return self.darkText
        case .lightText:
            return self.lightText
        case .intermediateText:
            return self.intermediateText
        case .affirmation:
            return self.affirmation
        case .negation:
            return self.negation
        case .empty:
            return .clear
        }
    }
    
    public func type(for color: UIColor) -> LUIColorType {
        
        var foundColor: LUIColorType = .empty
        
        LUIColorType.allCases.forEach { (type) in
            switch type {
            case .theme:
                if color.isEqual(self.theme) {
                    foundColor = type
                }
                break
            case .border:
                if color.isEqual(self.border) {
                    foundColor = type
                }
                break
            case .shadow:
                if color.isEqual(self.shadow) {
                    foundColor = type
                }
                break
            case .darkBackground:
                if color.isEqual(self.darkBackground) {
                    foundColor = type
                }
                break
            case .lightBackground:
                if color.isEqual(self.lightBackground) {
                    foundColor = type
                }
                break
            case .intermediateBackground:
                if color.isEqual(self.intermediateBackground) {
                    foundColor = type
                }
                break
            case .darkText:
                if color.isEqual(self.darkText) {
                    foundColor = type
                }
                break
            case .lightText:
                if color.isEqual(self.lightText) {
                    foundColor = type
                }
                break
            case .intermediateText:
                if color.isEqual(self.intermediateText) {
                    foundColor = type
                }
                break
            case .affirmation:
                if color.isEqual(self.affirmation) {
                    foundColor = type
                }
                break
            case .negation:
                if color.isEqual(self.negation) {
                    foundColor = type
                }
                break
            case .empty:
                break
            }
        }
        
        return foundColor
    }
}
