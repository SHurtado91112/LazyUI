//
//  LUIColor.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/6/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import Foundation
import UIKit

public enum LUIColorType {
    
    case theme
    case border
    case shadow
    
    case darkBackground
    case lightBackground
    case intermidiateBackground
    
    case darkText
    case lightText
    case intermidiateText
    
    case affirmation
    case negation

}


public struct LUIColor {
    
    public static var defaultTheme = LUIColor(theme: UIColor.blue, border: UIColor.gray, shadow: UIColor.black.withAlphaComponent(0.6), darkBackground: UIColor.darkGray, lightBackground: UIColor.white, intermediateBackground: UIColor.lightGray, darkText: UIColor.darkText, lightText: UIColor.white, intermediateText: UIColor.lightGray, affirmation: UIColor.green, negation: UIColor.red)
    
    public static var darkTheme = LUIColor(theme: UIColor.blue, border: UIColor.lightGray, shadow: UIColor.white.withAlphaComponent(0.6), darkBackground: UIColor.white, lightBackground: UIColor.darkGray, intermediateBackground: UIColor.lightGray, darkText: UIColor.white, lightText: UIColor.darkText, intermediateText: UIColor.lightGray, affirmation: UIColor.green, negation: UIColor.red)
    
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

}
