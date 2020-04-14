//
//  ExpenseDetailViewModel.swift
//  HealthExpLog
//
//  Created by ARMSTRONG on 1/27/20.
//  Copyright © 2020 ARMSTRONG. All rights reserved.
//

import Foundation

class ExpenseDetailViewModel {
    
    var medicalExpense: ExpenseActivity
    
    init(expense: ExpenseActivity) {
        self.medicalExpense = expense
    }

    var name: String {
        return medicalExpense.name
    }
    
    var date: String {
        return medicalExpense.date.string()
    }
    
    var provider: String {
        return medicalExpense.provider
    }
    
    var descriptionOfService: String {
        return medicalExpense.descriptionOfService
    }
    
    var EOBReceived: Bool {
        return medicalExpense.eobReceived
    }
    
    var amountBilled: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        
        let formattedValue = formatter.string(from: NSNumber(value: medicalExpense.amountBilled)) ?? ""
        
        return formattedValue
    }
 
    var amountPaidInsurance: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        
        let formattedValue = formatter.string(from: NSNumber(value: medicalExpense.amountPaidInsurance)) ?? ""
        
        return formattedValue
    }

    var amountPaidCopay: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2

        let formattedValue = formatter.string(from: NSNumber(value: medicalExpense.amountPaidCopay)) ?? ""
        
        return formattedValue
    }
    
    var amountPaidDeductible: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2

        let formattedValue = formatter.string(from: NSNumber(value: medicalExpense.amountPaidDeductible)) ?? ""
        
        return formattedValue
    }
    
    var amountStillDue: String {

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2

        let due = (medicalExpense.amountBilled - medicalExpense.amountPaidInsurance - medicalExpense.amountPaidCopay - medicalExpense.amountPaidDeductible)
        let formattedValue = formatter.string(from: NSNumber(value: due >= 0 ? due : 0)) ?? "0.0"
        
        return formattedValue
    }
    
    var methodOfPayment: ExpenseActivity.Category {
        return medicalExpense.methodOfPayment
    }

    var notes: String? {
        return medicalExpense.notes
    }
}
