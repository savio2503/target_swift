//
//  CompleteView.swift
//  target
//
//  Created by Sávio Dutra on 23/01/24.
//

import SwiftUI
import ComponentsCommunication

struct CompleteView: View {
    
    @Binding var targets: [Target]
    @Binding var total: Double
    @State var showMoney = false
    @StateObject var auth = AuthViewModel.shared

    var body: some View {
        NavigationStack {
            VStack {
                
                Text("Total value in complete: \(total.toCurrency() ?? "0.00")")
                    .padding(.top, 8)
                
                if targets.isEmpty {
                    
                    Spacer()
                    
                    Text("You haven't target completed")
                    
                    Spacer()
                    
                } else {
                    
                    ScrollView {
                        GroupTargetsView(listTarget: $targets, showMoney: $showMoney)
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    }
                    .scrollIndicators(.hidden)
                }
            }
        }
        .onAppear {
            print("onAppear CompleteView")
        }
    }
}

/*#Preview {
    CompleteView()
}*/
