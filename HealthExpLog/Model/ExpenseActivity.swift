//
//  ExpenseActivity.swift
//  HealthExpLog
//
//  Created by ARMSTRONG on 1/27/20.
//  Copyright © 2020 ARMSTRONG. All rights reserved.
//

import Foundation
import SwiftUI

struct ExpenseActivity: Identifiable {
        
    enum Category {
        case check
        case creditCard
        case cash
        case NA
    }
    
    var id: UUID = UUID()
    var name: String = ""
    var date: Date = Date.today
    var provider: String = ""
    var descriptionOfService: String = ""
    var eobReceived: Bool = false
    var amountBilled: Double = 0.0
    var amountPaidInsurance: Double = 0.0
    var amountPaidCopay: Double = 0.0
    var amountPaidDeductible: Double = 0.0
    var amountStillDue: Double = 0.0
    var methodOfPayment: Category = .check
    var notes: String?
}

#if DEBUG

let dummyTransactions = [ ExpenseActivity(name: "Jim Smith",
                                          date: Date.today,
                                          provider: "Michigan Medical, P LLC",
                                          descriptionOfService: "annual physical",
                                          eobReceived: true,
                                          amountBilled: 139.00,
                                          amountPaidInsurance: 139.00,
                                          amountPaidCopay:0.0,
                                          amountPaidDeductible: 0,
                                          amountStillDue: 0.0,
                                          methodOfPayment: .check,
                                          notes: "Test"
    ),
                          
                          ExpenseActivity(name: "Jim Smith",
                                          date: Date.fromString(string: "2019-02-15")!,
                                          provider: "Michigan Laboratory",
                                          descriptionOfService: "annual physical lab",
                                          eobReceived: false,
                                          amountBilled: 1000,
                                          amountPaidInsurance: 800,
                                          amountPaidCopay: 50,
                                          amountPaidDeductible: 100,
                                          amountStillDue: 0.0,
                                          methodOfPayment: .cash,
                                          notes: "Test"
    ),
    
]

#endif

