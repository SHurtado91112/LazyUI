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
    
    public init(theme: UIColor = UIColor(hexString: "#ffcc00"), border: UIColor = UIColor(hexString: "#333333"),
                shadow: UIColor = UIColor(hexString: "#cccccc"), darkBackground: UIColor = UIColor(hexString: "#999966"),
                lightBackground: UIColor = UIColor(hexString: "#cccc66"), intermediateBackground: UIColor = UIColor(hexString: "#cccc99"),
                darkText: UIColor = UIColor(hexString: "#333333"), lightText: UIColor = UIColor(hexString: "#cccccc"),
                intermediateText: UIColor = UIColor(hexString: "#999999"), affirmation: UIColor = UIColor(hexString: "#00ff66"), negation: UIColor = UIColor(hexString: "#ff3300")) {
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
