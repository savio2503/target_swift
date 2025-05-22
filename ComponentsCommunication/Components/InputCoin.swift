//
//  InputCoin.swift
//  ComponentsCommunication
//
//  Created by Sávio Dutra on 25/12/24.
//

import SwiftUI

public struct InputCoin: View {
    @Binding var value: Int
    
    @State private var textMenu = "R$"
    @State private var typeCoin = 1
    @State private var numberFormatter = NumberFormatter()
    @Environment(\.colorScheme) var colorScheme
    
    // Inicializador
    public init(value: Binding<Int>) {
        self._value = value
        self.numberFormatter.numberStyle = .currency
        self.numberFormatter.maximumFractionDigits = 2
        self.numberFormatter.locale = Locale(identifier: "pt_BR")
    }
    
    public var body: some View {
        HStack {
            // Menu para escolher a moeda
            Menu(textMenu) {
                Button("Real, R$") {
                    textMenu = "R$"
                    typeCoin = 1
                }
                Button("Dolar, U$") {
                    textMenu = "U$"
                    typeCoin = 2
                }
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue.opacity(0.8))
            .cornerRadius(8)
            
            // Campo de texto com formatação de moeda
            CurrencyTextField(numberFormatter: numberFormatter, value: $value)
                .padding()
                .background(colorScheme == .dark ? Color.black.opacity(0.3) : Color.white.opacity(0.8))
                .cornerRadius(5)
            #if !os(macOS)
                .keyboardType(.numberPad)
            #endif
                .frame(height: 50)
            
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }
}

