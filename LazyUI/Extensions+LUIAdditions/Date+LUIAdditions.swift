//
//  Date+LUIAdditions.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/21/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import Foundation

extension Date {
    
    public var year: String {
        return self.component(for: "yyyy")
    }
    
    public var month: String {
        return self.component(for: "LLLL")
    }
    
    public var day: String {
        return self.component(for: "dd")
    }
    
    public var weekday: String {
        return self.component(for: "EEEE")
    }
    
    func component(for format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
