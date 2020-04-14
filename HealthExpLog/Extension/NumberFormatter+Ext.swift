//
//  NumberFormatter+Ext.swift
//  HealthExpLog
//
//  Created by ARMSTRONG on 1/27/20.
//  Copyright © 2020 ARMSTRONG. All rights reserved.
//

import Foundation

extension NumberFormatter {
    static func currency(from value: Double)-> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        let formattedValue = formatter.string(from: NSNumber(value: value)) ?? ""
        
        return "$" + formattedValue
    }
}

