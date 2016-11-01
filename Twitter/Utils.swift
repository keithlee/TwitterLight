//
//  DateFormatter.swift
//  Twitter
//
//  Created by Keith Lee on 10/31/16.
//  Copyright © 2016 Keith Lee. All rights reserved.
//

import Foundation

class Utils {
    
    // define static variable
    
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        return formatter
    }()
    
    private static let newFormatter: DateFormatter = {
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "MM/dd/yy"
        return newFormatter
    }()
    
    // you could use it like so
    
    class func convert(date: String) -> String {
        let newDate = formatter.date(from: date)
        return newFormatter.string(from: newDate!)
    }
}
