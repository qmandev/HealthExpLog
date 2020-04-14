//
//  DashboardView.swift
//  HealthExpLog
//
//  Created by ARMSTRONG on 2/5/20.
//  Copyright © 2020 ARMSTRONG. All rights reserved.
//

import SwiftUI

enum TransactionDisplayType {
    case income
    case expense
    case all
}

struct DashboardView: View {
    
    private var totalIncome : Double {
        let total = expenseDateStore.expenseActivities
            .filter {
                $0.methodOfPayment == .cash
        }.reduce(0) {
            $0 + $1.amountBilled
        }
        
        return total
    }
    
    
    private var totalExpense : Double {
        let total = expenseDateStore.expenseActivities
            .filter {
                $0.methodOfPayment == .creditCard
        }.reduce(0) {
            $0 + $1.amountBilled
        }
        
        return total
    }
    
    private var totalBalance : Double {
        return totalIncome - totalExpense
    }

    private var expenseDataForView: [ExpenseActivity] {
        
        switch listType {
            case .all:
                return expenseDateStore.expenseActivities
                    .sorted(by: { $0.date.compare($1.date) == .orderedDescending})
            case .income:
                return expenseDateStore.expenseActivities
                    .filter {  $0.methodOfPayment == .cash  }
                    .sorted(by: { $0.date.compare($1.date) == .orderedDescending})
            case .expense:
                return expenseDateStore.expenseActivities
                    .filter {  $0.methodOfPayment == .creditCard  }
                    .sorted(by: { $0.date.compare($1.date) == .orderedDescending})
        }
    }
    
    
    @EnvironmentObject var expenseDateStore: ExpenseDataStore
    @State private var showExpenseDetails = false
    @State private var editExpenseDetails = false
    
    @State private var listType: TransactionDisplayType = .all
    @State private var selectExpenseActivity = ExpenseActivity()

    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: MedicalExpense.entity(), sortDescriptors: []) var expenses: FetchedResults<MedicalExpense>
    
    var body: some View {
        
        ZStack {
            List {
                
                ManuBar() {
                    VStack {
                        ExpenseFormView(expense: ExpenseActivity()).environmentObject(self.expenseDateStore)
                    }
                }
                .listRowInsets(EdgeInsets())
            
                /*
                VStack {
                    TotalBalanceCard(totalBalance: self.totalBalance)
                        .padding(.vertical)
                    
                    HStack {
                        IncomeCard(income: self.totalIncome)
                        
                        ExpenseCard(expense: self.totalBalance)
                    }
                    .padding(.bottom)

                    TransactionHeader(listType: self.$listType)
                        .padding(.bottom)
                }
                .padding(.horizontal)
                .listRowInsets(EdgeInsets())
                */
                
                /*
                Text("Count : \(self.expenses.count)")
                
                ForEach(self.expenses, id: \.id) {
                        item in
                            HStack {
                                Text("\(item.provider ?? "No Provider")")
                                    Spacer()
                                Text("\(item.notes ?? "No Notes")")
                            }
                    }
                }
                 */
                
                ForEach(expenseDataForView) { activity in
                    TransactionCellView(transaction: activity)
                        .onTapGesture {
                            self.showExpenseDetails = true
                            self.selectExpenseActivity = activity
                    }
                    .contextMenu {
                        // edit payment details
                        Button(action: {
                            self.editExpenseDetails = true
                            self.selectExpenseActivity = activity
                        }) {
                            HStack {
                                Text("Edit")
                                Image(systemName: "pencil")
                            }

                        }

                        // delete payment details
                        Button(action: {
                            self.expenseDateStore.remove(activity: activity)
                        }) {
                            HStack {
                                Text("Delete")
                                Image(systemName: "trash")
                            }

                        }
                    }
                }.sheet(isPresented: self.$editExpenseDetails) {
                    ExpenseFormView(expense: self.selectExpenseActivity).environmentObject(self.expenseDateStore)
                }
            }
            .offset(y: self.showExpenseDetails ? -100 : 0)
            .animation(.easeOut(duration: 0.4))
            
            if self.showExpenseDetails {
                BlankView(bgColor: .black)
                    .opacity(0.5)
                    .onTapGesture {
                        self.showExpenseDetails = false
                }
                
                ExpenseDetailView(isShow: self.$showExpenseDetails, activity: self.selectExpenseActivity)
            }

        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}


struct ManuBar<Content>: View where Content: View {
    
    @State private var showPaymentForm = false
    
    let modalContent: () -> Content
    
    var body: some View {
        
        HStack {
            Spacer()
            VStack(alignment: .center) {
                Spacer()
                Text(Date.today.string(with: "EEEE, MMM d, yyyy"))
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
                Text("Medical Expenses & Claims")
                    .font(.system(size: 22))
                    .foregroundColor(Color.black)
            }
            Spacer()
            
            Button(action: {
                self.showPaymentForm = true
            }) {
                Image(systemName: "plus.circle")
                    .font(.title)
                    .foregroundColor(Color.black)
            }
            .sheet(isPresented: self.$showPaymentForm, onDismiss: {
                self.showPaymentForm = false
            }) {
                self.modalContent()
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 5)
    }
}


struct ExpenseCard: View {
    
    var expense = 800.0 // 0.0
    
    var body: some View {
        
        VStack {
                Text("Expense")
                    .font(.system(Font.TextStyle.title, design: Font.Design.rounded))
                    .foregroundColor(.white)
                    .fontWeight(Font.Weight.black)
                        
                Text(NumberFormatter.currency(from: expense))
                    .font(.system(Font.TextStyle.title, design: Font.Design.rounded))
                    .fontWeight(Font.Weight.black)
        }
    }
}

struct IncomeCard: View {
    
    var income = 700.0 // 0.0
    
    var body: some View {
        
        VStack {
            Text("Income")
                .font(.system(Font.TextStyle.title, design: Font.Design.rounded))
                .foregroundColor(.white)
                .fontWeight(Font.Weight.black)
                    
            Text(NumberFormatter.currency(from: income))
                .font(.system(Font.TextStyle.title, design: Font.Design.rounded))
                .fontWeight(Font.Weight.black)
        }
    }
}

struct TotalBalanceCard: View {
    
    var totalBalance = 1000.0 // 0.0
    
    var body: some View {
        
        VStack {
            Text("Total Balance")
                .font(.system(Font.TextStyle.title, design: Font.Design.rounded))
                .foregroundColor(.white)
                .fontWeight(Font.Weight.black)
                    
            Text(NumberFormatter.currency(from: totalBalance))
                .font(.system(Font.TextStyle.title, design: Font.Design.rounded))
                .fontWeight(Font.Weight.black)
        }
    }
}



struct TransactionHeader: View {
    
    @Binding var listType: TransactionDisplayType
    
    var body: some View {
        
        VStack {
            HStack {
                Text("Recent Expenses")
                    .font(.headline)
                    .foregroundColor(Color("Heading"))
                Spacer()
            }.padding(Edge.Set.bottom, 5)

            HStack {
                Group {
                    Text("All")
                        .padding(3)
                        .padding(Edge.Set.horizontal, 10)
                        .foregroundColor(listType == TransactionDisplayType.all ? Color("PrimaryButton") : Color("SecondaryButton"))
                        .onTapGesture {
                            self.listType = .all
                    }
                    
                    Text("Income")
                        .padding(3)
                        .padding(Edge.Set.horizontal, 10)
                        .foregroundColor(listType == TransactionDisplayType.income ? Color("PrimaryButton") : Color("SecondaryButton"))
                        .onTapGesture {
                            self.listType = .income
                    }
                    
                    Text("Expense")
                        .padding(3)
                        .padding(Edge.Set.horizontal, 10)
                        .foregroundColor(listType == TransactionDisplayType.expense ? Color("PrimaryButton") : Color("SecondaryButton"))
                        .onTapGesture {
                            self.listType = .expense
                    }
                }
            }  // VStack
        }
    }
}


struct TransactionCellView: View {
    var transaction: ExpenseActivity
    
    var body: some View {
        
        HStack(spacing: 20) {
            Image(systemName: "circle.fill")
                .font(.headline)
                .foregroundColor(transaction.amountStillDue > 0 ? Color("ExpenseCard") : Color("IncomeCard"))
            VStack(alignment: .leading) {
                Text("\(transaction.name)")
                    .font(.system(Font.TextStyle.body, design: .rounded))
                Text("\(transaction.provider)")
                    .font(.system(Font.TextStyle.body, design: .rounded))
                Text("\(transaction.date.string())")
                    .font(.system(Font.TextStyle.footnote, design: .rounded))
                    .foregroundColor(Color.gray)
            }
            
            Spacer()
            VStack(alignment: .trailing) {
                Text("Due")
                    .font(.system(Font.TextStyle.subheadline, design: .rounded))
                Text(NumberFormatter.currency(from: (transaction.amountBilled - transaction.amountPaidInsurance - transaction.amountPaidCopay - transaction.amountPaidDeductible)) )
                    .font(.system(Font.TextStyle.title, design: .rounded))
            }
        }.padding(Edge.Set.vertical, 5)
    }
}


struct BlankView: View {
    
    var bgColor: Color

    var body: some View {
        VStack {
            Text("BlankView !")
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(bgColor)
        .edgesIgnoringSafeArea(.all)
    }
}

