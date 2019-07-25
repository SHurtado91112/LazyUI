//
//  String+LUIAdditions.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/21/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import Foundation

extension String {
    public var removingPunctuation: String {
        var words: String = self
        
        while true {
            if let forbiddenCharRange = words.rangeOfCharacter(from: CharacterSet.punctuationCharacters) {
                words.removeSubrange(forbiddenCharRange)
            }
            else {
                break
            }
        }
        
        return words
    }
}
