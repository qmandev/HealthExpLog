//
//  Date+Ext.swift
//  HealthExpLog
//
//  Created by ARMSTRONG on 1/27/20.
//  Copyright © 2020 ARMSTRONG. All rights reserved.
//

import Foundation

extension Date {
    
    static var today: Date {
        return Date()
    }
    
    static var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    }
    
    static var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    }

    static func fromString(string: String, with format: String = "yyyy-MM-dd") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: string)
    }

    func string(with format: String = "MMM dd yyyy") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
