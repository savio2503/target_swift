//
//  MoneyVIew.swift
//  target
//
//  Created by Sávio Dutra on 12/01/24.
//

import SwiftUI

struct MoneyView: View {
    
    @State var valor: Double = 0.0
    @State var send = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Quanto voce irá depositar ou remover?")
                    .padding(.top, 150)
                
                TextField(
                    "Valor", value: $valor, format:  .currency(code: "BRL")
                )
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(5.0)
                .padding(.top, 20)
                .padding(.horizontal, 20)
                .keyboardType(.numberPad)
                
                Spacer()
                
                if !send {
                    HStack {
                        
                        Spacer()
                        
                        Button(action: {
                            print("tocou em deposit")
                            
                            send = true
                            
                            Task {
                                await sendMoney()
                                dismiss()
                            }
                        }) {
                            HStack {
                                Text("Deposit")
                                    .foregroundStyle(.blue)
                                    .padding(.horizontal, 10)
                            }
                            .padding()
                            .background(Color("CardColor"))
                            .cornerRadius(30.0)
                        }
                        .padding()
                        
                        Spacer()
                        
                        Button(action: {
                            print("tocou em Withdrawal")
                            
                            send = true
                            valor = -1*valor
                            
                            Task {
                                await sendMoney()
                                dismiss()
                            }
                        }) {
                            HStack {
                                Text("Withdrawal")
                                    .foregroundStyle(.red)
                                    .padding(.horizontal, 10)
                            }
                            .padding()
                            .background(Color("CardColor"))
                            .cornerRadius(30.0)
                        }
                        .padding()
                        
                        Spacer()
                    }
                    .padding(.bottom, 50)
                } else {
                    
                    Text("Enviando...")
                        .padding(.bottom, 50)
                }
            }
            .navigationTitle("Add a new Deposit or Withdrawal")
            .navigationBarTitleDisplayMode(.inline)
        }//: NAVIGATION STACK
    }
    
    func sendMoney() async {
        
        let _value = self.valor
        
        do {
            try await Api.shared.deposit(amount: _value)
        } catch {
            print("\(error.localizedDescription)")
        }
        
        send = false
        
    }
}

#Preview {
    MoneyView()
}
