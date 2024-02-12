//
//  MoneyVIew.swift
//  target
//
//  Created by Sávio Dutra on 12/01/24.
//

import SwiftUI

struct MoneyVIew: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Money view")
            }
            .navigationTitle("Add a new Deposit or Withdrawal")
            .navigationBarTitleDisplayMode(.inline)
        }//: NAVIGATION STACK
    }
}

#Preview {
    MoneyVIew()
}
