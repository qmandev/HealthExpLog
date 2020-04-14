//
//  ExpenseFormView.swift
//  HealthExpLog
//
//  Created by ARMSTRONG on 2/5/20.
//  Copyright © 2020 ARMSTRONG. All rights reserved.
//

import SwiftUI

struct ExpenseFormView: View {
    
    var medicalExpense: ExpenseActivity?
    
    @ObservedObject private var keyboard = KeyboardResponder()
    
    @ObservedObject private var expenseFormViewModel: ExpenseFormViewModel
    
    @EnvironmentObject var expenseDataStore: ExpenseDataStore
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init(expense: ExpenseActivity) {
        self.medicalExpense = expense
        self.expenseFormViewModel = ExpenseFormViewModel(expenseActivity: expense )
    }
    
    var body: some View {

    ZStack {
              
          Image("background")
              .resizable()
              .aspectRatio(contentMode: ContentMode.fill)
              .frame(minWidth: 0, maxWidth: .infinity)
            
         ScrollView {
              
          VStack {
              
              // Title Bar
              HStack {
                  // TODO: to use custom font here
                  Text("New Medical Expense")
                    .font(.system(Font.TextStyle.title, design: Font.Design.rounded))
                    .fontWeight(.medium)
                    .padding(.all)
                  Spacer()
                  
                  Button(action: {
                      self.presentationMode.wrappedValue.dismiss()
                  }) {
                      Image(systemName: "multiply.circle")
                          .foregroundColor(.primary)
                          .font(.title)
                  }.padding(.trailing, 5)
              }.padding(.top, Device.IS_IPAD ? 120 : 20) // HStack
            
              Group {
                  if !expenseFormViewModel.isNameValid {
                        ValidationErrorText(text: "Please enter a valid family member name")
                  }
                  if !expenseFormViewModel.isProviderValid {
                        ValidationErrorText(text: "Please enter a valid Provider")
                  }
                  if !expenseFormViewModel.isDateValid {
                        ValidationErrorText(text: "Please enter a valid date")
                  }
                  if !expenseFormViewModel.isNotesValid {
                        ValidationErrorText(text: "Your note should not exceed 300 characters")
                  }
              }.padding(.leading, 5)
              
            // Name field
            FormTextFieldView(name: "Family Member", placeHolder: "Enter your family member name", value: $expenseFormViewModel.name).padding(.top)
            
            // Provider field
            FormTextFieldView(name: "Provider", placeHolder: "Enter your medical service provider", value: $expenseFormViewModel.provider).padding(.top)
                        
              // Date and Amount
              VStack {
                FormTextFieldViewHorizontal(name: "Date", placeHolder: "mm/dd/yy", value: $expenseFormViewModel.date)
                  
                FormToggleView(name: "EOB Received", placeHolder: "", value: $expenseFormViewModel.eobReceived)
              }.padding(.top)
            
            // Amount Billed and Insurance Paid
            HStack {
              FormTextFieldView(name: "Amount Billed($)", placeHolder: "Enter your amount billed", value: $expenseFormViewModel.amountBilled)
                
                FormTextFieldView(name: "Insurance Paid($)", placeHolder: "Enter your insurance paid", value: $expenseFormViewModel.amountPaidInsurance)
            }.padding(.top)
            
            // Amount Billed and Insurance Paid
            HStack {
                FormTextFieldView(name: "Copay Paid($)", placeHolder: "Enter your amount copay paid", value: $expenseFormViewModel.amountPaidCopay)
                
                FormTextFieldView(name: "Deductible Paid($)", placeHolder: "Enter deductible paid", value: $expenseFormViewModel.amountPaidDeductible)
            }.padding(.top)
              
              // Location
            FormTextFieldView(name: "Description Of Service", placeHolder: "Enter your Description of Service", value: $expenseFormViewModel.descriptionOfService)
              
              // Memo
            FormTextFieldView(name: "Notes (Optional)", placeHolder: "Your personal note", value: $expenseFormViewModel.notes)
            
            // Save button
             Button(action: {
                self.save()
                self.presentationMode.wrappedValue.dismiss()
             }) {
                 Text("Save")
                     .opacity(0.5)
                     .font(.headline)
                     .foregroundColor(.white)
                     .padding()
                     .frame(minWidth: 0, maxWidth: .infinity)
                     .background(Color("IncomeCard"))
                     .cornerRadius(10)
                     
             }
             .padding()
             .disabled(!expenseFormViewModel.isFormInputValid)

          }
          .offset(y: Device.IS_IPHONE ? -self.keyboard.keyboardHeight*CGFloat(0.8) : CGFloat(0.0))
                // Vstack
         }
        // Scorll View,
          // Scorll View, Makes it go up, since negative offset
    } // Zstack
    }
    
    private func save() {
        
        var newExpense = medicalExpense ?? ExpenseActivity()
        
        newExpense.name = self.expenseFormViewModel.name
        newExpense.provider = self.expenseFormViewModel.provider
        newExpense.date = Date.fromString(string: self.expenseFormViewModel.date, with: "MM/dd/yyyy")!
        newExpense.eobReceived = self.expenseFormViewModel.eobReceived
        newExpense.amountBilled = Double(self.expenseFormViewModel.amountBilled)!
        newExpense.amountPaidInsurance = Double(self.expenseFormViewModel.amountPaidInsurance)!
        newExpense.amountPaidCopay = Double(self.expenseFormViewModel.amountPaidCopay)!
        newExpense.amountPaidDeductible = Double(self.expenseFormViewModel.amountPaidDeductible)!
        newExpense.amountStillDue = Double(self.expenseFormViewModel.amountStillDue)!
        newExpense.descriptionOfService = self.expenseFormViewModel.descriptionOfService
        newExpense.notes = self.expenseFormViewModel.notes
        newExpense.methodOfPayment = .cash

        expenseDataStore.update(activity: newExpense)
    }
}

struct ExpenseFormView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            ExpenseFormView(expense: ExpenseActivity())
   
            ValidationErrorText(text: "Validation Error").previewLayout(PreviewLayout.sizeThatFits)
            
            FormTextFieldView(name: "Name", placeHolder: "Enter your medical expense", value: .constant("")).previewLayout(PreviewLayout.sizeThatFits)
            
            FormTextFieldViewHorizontal(name: "Name", placeHolder: "Enter your medical expense", value: .constant("")).previewLayout(PreviewLayout.sizeThatFits)
            
            FormToggleView(name: "Toggle", placeHolder: "", value: .constant(true)).previewLayout(PreviewLayout.sizeThatFits)
        }
    }
}


struct FormTextFieldView: View {
    
    let name: String
    var placeHolder: String
    let prefix: String = ""
    
    @Binding var value: String

    var body: some View {
        VStack {
            
            Text(name.uppercased())
                .font(.system(Font.TextStyle.body, design: Font.Design.rounded))
                .fontWeight(Font.Weight.bold)
                .foregroundColor(.primary)
            
            TextField(placeHolder, text: $value)
                .font(.headline)
                .foregroundColor(.primary)
                .padding()
                .border(Color("Border"), width: 1.0)
        }
    }
}

struct FormTextFieldViewHorizontal: View {
    
    let name: String
    var placeHolder: String
    let prefix: String = ""
    
    @Binding var value: String

    var body: some View {
        HStack {
            Spacer()
            
            Text(name.uppercased())
                .font(.system(Font.TextStyle.body, design: Font.Design.rounded))
                .fontWeight(Font.Weight.bold)
                .foregroundColor(.primary)
            
            TextField(placeHolder, text: $value)
                .font(.headline)
                .foregroundColor(.primary)
                .padding()
                .border(Color("Border"), width: 1.0)
            
            Spacer()
        }
    }
}

struct FormToggleView: View {
    
    let name: String
    var placeHolder: String
    let prefix: String = ""
    
    @Binding var value: Bool

    var body: some View {

        HStack {
                Spacer()
                Toggle(isOn: $value) {
                Text(name.uppercased())
                    .font(.system(Font.TextStyle.body, design: Font.Design.rounded))
                    .fontWeight(Font.Weight.bold)
                    .foregroundColor(.primary)
                }.padding(.horizontal)
                Spacer()
        }
    }
}


struct ValidationErrorText: View {
    
    var iconName = "info.circle"
    var iconColor = Color(red: 251/255, green: 128/255, blue: 128/255)
    
    var text = ""
    
    var body: some View {
        HStack {
            Image(systemName: iconName).foregroundColor(iconColor)
            Text(text)
                .font(.system(Font.TextStyle.body, design: Font.Design.rounded))
                .foregroundColor(.secondary)
            Spacer()
        }
    }
}

struct Device {
    static let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE = UIDevice.current.userInterfaceIdiom == .phone
}
