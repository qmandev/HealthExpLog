//
//  ExpenseFormViewModel.swift
//  HealthExpLog
//
//  Created by ARMSTRONG on 1/27/20.
//  Copyright © 2020 ARMSTRONG. All rights reserved.
//

import Foundation
import Combine

class ExpenseFormViewModel: ObservableObject {
    
    // Input
    @Published var name = ""
    @Published var date = Date.today.string(with: "MM/dd/yyyy")
    @Published var eobReceived = false
    @Published var provider = ""
    @Published var descriptionOfService = ""
    @Published var amountBilled = ""
    @Published var amountPaidInsurance = ""
    @Published var amountPaidCopay = ""
    @Published var amountPaidDeductible = ""
    @Published var amountStillDue = ""    
    @Published var methodOfPayment = ExpenseActivity.Category.cash
    @Published var notes = ""

    // Output
    @Published var isNameValid = false
    @Published var isDateValid = false
    @Published var isProviderValid = false
    @Published var isDescriptionOfServiceValid = false
    @Published var isAmountBilledValid = true
    @Published var isAmountPaidInsuranceValid = true
    @Published var isAmountPaidCopayValid = true
    @Published var isAmountPaidDeductibleValid = true
    @Published var isAmountStillDueValid = true
    @Published var isMethodOfPaymentValid = false
    @Published var isNotesValid = false
    
    @Published var isFormInputValid = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(expenseActivity: ExpenseActivity = ExpenseActivity()) {
  
        self.name = expenseActivity.name
        self.date = expenseActivity.date.string(with: "MM/dd/yyyy")
        self.eobReceived = expenseActivity.eobReceived
        self.provider = expenseActivity.provider
        self.descriptionOfService = expenseActivity.descriptionOfService
        self.amountBilled = "\(expenseActivity.amountBilled)"
        self.amountPaidInsurance = "\(expenseActivity.amountPaidInsurance)"
        self.amountPaidCopay = "\(expenseActivity.amountPaidCopay)"
        self.amountPaidDeductible = "\(expenseActivity.amountPaidDeductible)"
        self.amountStillDue = "\(expenseActivity.amountStillDue)"
      
        self.methodOfPayment = expenseActivity.methodOfPayment
        
        /*
        guard let notes = expenseActivity.notes else {
            self.notes = ""
            return
        }*/
        self.notes =  expenseActivity.notes ?? ""

        $name.receive(on: RunLoop.main)
            .map { name in return name.count > 0}
            .assign(to: \.isNameValid, on: self)
            .store(in: &cancellableSet)
        
        $date.receive(on: RunLoop.main)
            .map { date in Date.fromString(string: date, with: "MM/dd/yyyy") != nil }
            .assign(to: \.isDateValid, on: self)
            .store(in: &cancellableSet)
        
        $provider.receive(on: RunLoop.main)
            .map { provider in return provider.count > 0}
            .assign(to: \.isProviderValid, on: self)
            .store(in: &cancellableSet)
        
        $descriptionOfService.receive(on: RunLoop.main)
            .map { descriptionOfService in return descriptionOfService.count > 0}
            .assign(to: \.isDescriptionOfServiceValid, on: self)
            .store(in: &cancellableSet)
        
        $amountBilled.receive(on: RunLoop.main)
            .map { amount in
                guard let validAmount = Double(amount) else {
                    return false
                }
                return validAmount >= 0
            }
            .assign(to: \.isAmountBilledValid, on: self)
            .store(in: &cancellableSet)
        
        $amountPaidInsurance.receive(on: RunLoop.main)
            .map { amount in
                guard let validAmount = Double(amount) else {
                    return false
                }
                return validAmount >= 0
            }
            .assign(to: \.isAmountPaidInsuranceValid, on: self)
            .store(in: &cancellableSet)
        
        $amountPaidCopay.receive(on: RunLoop.main)
            .map { amount in
                guard let validAmount = Double(amount) else {
                    return false
                }
                return validAmount >= 0
            }
            .assign(to: \.isAmountPaidCopayValid, on: self)
            .store(in: &cancellableSet)
        
        $amountPaidDeductible.receive(on: RunLoop.main)
            .map { amount in
                guard let validAmount = Double(amount) else {
                    return false
                }
                return validAmount >= 0
            }
            .assign(to: \.isAmountPaidDeductibleValid, on: self)
            .store(in: &cancellableSet)
        
        $amountStillDue.receive(on: RunLoop.main)
            .map { amount in
                guard let validAmount = Double(amount) else {
                    return false
                }
                return validAmount >= 0
            }
            .assign(to: \.isAmountStillDueValid, on: self)
            .store(in: &cancellableSet)
        
        $notes.receive(on: RunLoop.main)
            .map { note in return note.count < 300}
            .assign(to: \.isNotesValid, on: self)
            .store(in: &cancellableSet)
        
        // TODO: will need to add the four amount validation
        Publishers.CombineLatest4($isNameValid, $isDateValid, $isProviderValid, $isNotesValid)
            .receive(on: RunLoop.main)
            .map { (isNameValid, isDateValid, isProviderValid, isNotesValid) in
                return isNameValid && isDateValid && isProviderValid  && isNotesValid
            }
            .assign(to: \.isFormInputValid, on: self)
            .store(in: &cancellableSet)
    }

}
