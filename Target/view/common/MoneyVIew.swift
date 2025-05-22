//
//  MoneyVIew.swift
//  target
//
//  Created by Sávio Dutra on 12/01/24.
//

import SwiftUI
import ComponentsCommunication

struct MoneyView: View {
    
    @State var valor = 0
    @State var send = false
    @Environment(\.dismiss) private var dismiss
    @State var numberFormatter: NumberFormatter
    @Environment(\.colorScheme) var colorScheme
    var tintColor: Color {
        colorScheme == .dark ? Color.white : Color.black
    }
    
    init() {
        self.numberFormatter = NumberFormatter()
        self.numberFormatter.numberStyle = .currency
        self.numberFormatter.maximumFractionDigits = 2
        self.numberFormatter.locale = Locale(identifier: "pt_BR")
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Quanto voce irá depositar ou remover?")
                    .padding(.top, 150)
                
                CurrencyTextField(numberFormatter: numberFormatter, value: $valor)
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .tint(tintColor)
                    .cornerRadius(5.0)
                    .frame(height: 50)
                
                Spacer()
                
                if !send {
                    HStack {
                        
                        Spacer()
                        
                        Button(action: {
                            send = true
                            KeysStorage.shared.recarregar = true
                            
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
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Spacer()
                        
                        Button(action: {
                            send = true
                            valor = -1*valor
                            KeysStorage.shared.recarregar = true
                            
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
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Spacer()
                    }
                    .padding(.bottom, 50)
                } else {
                    
                    Text("Enviando...")
                        .padding(.bottom, 50)
                }
            }
            .frame(width: 400)
            .navigationTitle("Add a new Deposit or Withdrawal")
            #if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
        }//: NAVIGATION STACK
    }
    
    func sendMoney() async {
        
        let _value = Double (self.valor) / 100.0
        
        do {
            try await Api.shared.deposit(amount: _value)
        } catch {
            print("\(error.localizedDescription)")
        }
        
        send = false
        
    }
}

/*
#Preview {
    MoneyView()
}*/
