//
//  ProgressView.swift
//  target
//
//  Created by Sávio Dutra on 23/01/24.
//

import SwiftUI
import ComponentsCommunication

struct ProgressView: View {

    @Binding var targets: [Target]
    @Binding var total: Double
    @Binding var showMoney: Bool
    @Binding var porcentagem: Double
    @StateObject var auth = AuthViewModel.shared

    var body: some View {
        NavigationStack {
            VStack {
                
                Text("Total value in progress: \(total.toCurrency() ?? "0.00") = \(porcentagem, specifier: "%.2f")%")
                    .padding(.top, 8)
                
                if (targets.isEmpty) {
                    
                    Spacer()
                    
                    Text("You haven't target created")
                    
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
            print("onAppear ProgressView")
        }
    }
    
    
}

/*#Preview {
    //let targets = [Target(id: 1, descricao: "teste", valor: 20.5, posicao: 1, imagem: " ")]
    ProgressView()//(targets: targets)
}*/
