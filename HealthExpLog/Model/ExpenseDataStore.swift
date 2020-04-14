//
//  ExpenseDataStore.swift
//  HealthExpLog
//
//  Created by ARMSTRONG on 1/27/20.
//  Copyright © 2020 ARMSTRONG. All rights reserved.
//

import Foundation
import Combine
import CoreData
import SwiftUI

class ExpenseDataStore: ObservableObject {
    
    private var expenses : [MedicalExpense] = []
    @Published var expenseActivities: [ExpenseActivity] = []
    
    init(expenseActivities: [ExpenseActivity] = []) {
        
        self.expenseActivities = expenseActivities
        
        // var localexpenses : [MedicalExpense] = []

        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let request: NSFetchRequest<MedicalExpense> = MedicalExpense.fetchRequest()
            let context = appDelegate.persistentContainer.viewContext
            
        do {
            self.expenses = try context.fetch(request)
            } catch {
                print(error)
            }
            print("expense : Retriving data from context ...")

            for item in self.expenses {
                let activity = convertManagedObjectToActivity(expense: item)
                self.expenseActivities.append(activity)
            }
            
            // self.expenseActivities.append(activity)
        }
    }
    
    func add(activity: ExpenseActivity) {
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            
            let context = appDelegate.persistentContainer.viewContext
            
            /*
            do {
                var expenseWithID = try context.fetch(request)
                } catch {
                    print(error)
                }
                print("expense : Retriving data from context ...")

                
                for item in self.expenses {
                    let activity = convertManagedObjectToActivity(expense: item)
                    self.expenseActivities.append(activity)
                }
                
                
                // self.expenseActivities.append(activity)
            }*/
            // End of Save + Edit
            
            var expense = MedicalExpense(context: appDelegate.persistentContainer.viewContext)
            // var expense = MedicalExpense(context: self.moc)
            expense = convertActivityToManagedObject(activity: activity, expense: expense)
            

            
            try? context.save()
            print("expense : Saving data to context ...")
            self.expenseActivities.append(activity)
            //try? self.moc.save()
        }
    }
    
    func update(activity: ExpenseActivity) {
        
        /*
        guard let index = self.expenseActivities.firstIndex(where: { ( activity.id == $0.id )}) else {
            return
        }
        
        self.expenseActivities[index] = activity
        */
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            
            guard let index = self.expenseActivities.firstIndex(where: { ( activity.id == $0.id )}) else {
                add(activity: activity)
                
                return
            }
            
            self.expenseActivities[index] = activity
            
            // var expense = MedicalExpense(context: appDelegate.persistentContainer.viewContext)

            // expense = convertActivityToManagedObject(activity: activity, expense: expense)
            
            // Save + Edit:
            /*
            let request: NSFetchRequest<MedicalExpense> = MedicalExpense.fetchRequest()
            let predicate = NSPredicate(format: "id == \(activity.id)")
            request.predicate = predicate
            
            let context = appDelegate.persistentContainer.viewContext
            
            do {
                var expenseFatched = try context.fetch(request as! NSFetchRequest<NSFetchRequestResult>) as! [MedicalExpense]
                
                guard let index = expenseFatched.firstIndex(where: { ( activity.id == $0.id )}) else {
                    return
                }
                
                expenseFatched[index] = convertActivityToManagedObject(activity: activity, expense: expenseFatched[index] )
                
            } catch {
                fatalError("Failed to Medical Expense: \(error)")
            }
            */
            
            guard let indexMOC = self.expenses.firstIndex(where: { ( activity.id == $0.id )}) else {
                return
            }
            
            self.expenses[indexMOC] = convertActivityToManagedObject(activity: activity, expense: self.expenses[indexMOC])
            
            let context = appDelegate.persistentContainer.viewContext
            try? context.save()
            print("expense : Updating data from context ...")
            appDelegate.saveContext()

        }
    }
    
    func remove(activity: ExpenseActivity) {
    
        /*
        guard let index = self.expenseActivities.firstIndex(where: { ( activity.id == $0.id )}) else {
            return
        }
        
        self.expenseActivities.remove(at: index)
        */
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            // var expense = MedicalExpense(context: appDelegate.persistentContainer.viewContext)
            let context = appDelegate.persistentContainer.viewContext

            guard let indexMOC = self.expenses.firstIndex(where: { ( activity.id == $0.id )}) else {
                return
            }
            
            let expense = self.expenses[indexMOC]
            context.delete(expense)
            print("expense : Removing data from context ...")
            appDelegate.saveContext()
            
            guard let index = self.expenseActivities.firstIndex(where: { ( activity.id == $0.id )}) else {
                return
            }
            
            self.expenseActivities.remove(at: index)
        }
    }
    
    func convertActivityToManagedObject(activity: ExpenseActivity, expense: MedicalExpense) -> MedicalExpense {
        
        expense.id = activity.id
        expense.name = activity.name
        expense.provider = activity.provider
        expense.descriptionOfService = activity.descriptionOfService
        expense.date = activity.date
        expense.eobReceived = activity.eobReceived
        expense.amountBilled = activity.amountBilled
        expense.amountPaidCopay = activity.amountPaidCopay
        expense.amountPaidDeductible = activity.amountPaidDeductible
        expense.amountPaidInsurance = activity.amountPaidInsurance
        expense.amountStillDue = activity.amountStillDue

        return expense
    }
    
    func convertManagedObjectToActivity(expense: MedicalExpense) -> ExpenseActivity {
        
        let activity = ExpenseActivity(
            id: expense.id ?? UUID(),
            name: expense.name ?? "No Name",
            date: expense.date ?? Date.init(),
            provider: expense.provider ?? "No Provider",
            descriptionOfService: expense.descriptionOfService ?? "No Provider",
            eobReceived: expense.eobReceived,
            amountBilled: expense.amountBilled,
            amountPaidInsurance: expense.amountPaidInsurance,
            amountPaidCopay: expense.amountPaidCopay,
            amountPaidDeductible: expense.amountPaidDeductible,
            amountStillDue: expense.amountStillDue
        )
        return activity
    }
}
