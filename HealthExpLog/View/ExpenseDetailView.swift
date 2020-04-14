//
//  ExpenseDetailView.swift
//  HealthExpLog
//
//  Created by ARMSTRONG on 2/5/20.
//  Copyright © 2020 ARMSTRONG. All rights reserved.
//

import SwiftUI

struct ExpenseDetailView: View {
    
    @Binding var isShow: Bool
    
    let activity: ExpenseActivity
    
    private var viewModel: ExpenseDetailViewModel
    
    init(isShow: Binding<Bool>, activity: ExpenseActivity) {
        self._isShow = isShow
        self.activity = activity
        
        self.viewModel = ExpenseDetailViewModel(expense: activity)
    }
    
    var body: some View {

        BottomSheetView(isShow: $isShow) {
            
            ZStack {
                
            Image("background")
                .resizable()
                .aspectRatio(contentMode: ContentMode.fill)
                .frame(minWidth: 0, maxWidth: .infinity)
            
            VStack(alignment: .leading) {
                TitleBarView(viewModel: self.viewModel)
                
                Image(systemName: "folder.fill.badge.plus")
                    .resizable()
                    .aspectRatio(contentMode: ContentMode.fit)
                    .frame(minWidth: 0, maxWidth: 80)
                    .foregroundColor(Color("TotalBalanceCard"))
                    .padding(.leading)

                // Medical Expense Details
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(self.viewModel.name)")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("Subheadline"))

                        Text("\(self.viewModel.date)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("Subheadline"))
                        
                        Text("\(self.viewModel.provider)")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("Subheadline"))
                        
                        Text("EOB Received : \(self.viewModel.EOBReceived ? "YES" : "NO")")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("Subheadline"))
                        
                        Text("\(self.viewModel.descriptionOfService)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("Subheadline"))
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                    }.padding(Edge.Set.horizontal)

                    Spacer()
                    
                    VStack(alignment: .trailing){
                        
                        Text("Total Amount Billed")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text("\(self.viewModel.amountBilled)")
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Text("Insurance Paid")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text("\(self.viewModel.amountPaidInsurance)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text("Copay Paid")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text("\(self.viewModel.amountPaidCopay)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text("Deductible Paid")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text("\(self.viewModel.amountPaidDeductible)")
                            .font(.subheadline)
                            .fontWeight(.semibold)

                        Text("Amount Due")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text("\(self.viewModel.amountStillDue)")
                            .font(.title)
                            .fontWeight(.semibold)
                        }.padding(.trailing)
                } // HStack
                
                Divider().padding(.horizontal)
                
                if self.viewModel.notes != "" {
                    Group {
                        Text("Notes")
                            .font(.subheadline)
                            .fontWeight(Font.Weight.bold)
                            .padding(.bottom, 5)

                        Text("\(self.viewModel.notes ?? "No Notes")")
                            .font(.subheadline)
                        
                        Divider().padding(.horizontal)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                }
            }  // Top VStack
        } // Top ZStack
        }
    }
}

struct ExpenseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
    Group {
        /*
        ExpenseDetailView(isShow: .constant(true), activity: dummyTransactions[1])
        
        TitleBarView(viewModel: ExpenseDetailViewModel(expense: dummyTransactions[1])).previewLayout(PreviewLayout.sizeThatFits)
        }
        */
        ExpenseDetailView(isShow: .constant(true), activity: ExpenseActivity())
        
        TitleBarView(viewModel: ExpenseDetailViewModel(expense: ExpenseActivity())).previewLayout(PreviewLayout.sizeThatFits)
        }
    }
}

struct TitleBarView: View {
    
    var viewModel: ExpenseDetailViewModel
    
    var body: some View {
        
        HStack {
            Spacer()
            Text("Medical Expense Details")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color("Heading"))
            
            /*
            Image(systemName: "folder.fill.badge.plus")
                .foregroundColor(Color("TotalBalanceCard"))
            */
            Spacer()

        }.padding()
    }
}

