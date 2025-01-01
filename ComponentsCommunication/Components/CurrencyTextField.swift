//
//  CurrencyTextField.swift
//  target
//
//  Created by Sávio Dutra on 05/07/24.
//

import SwiftUI

public struct CurrencyTextField: UIViewRepresentable {
    
    public typealias UIViewType = CurrencyUITextField
    
    let numberFormatter: NumberFormatter
    let currencyField: CurrencyUITextField
    
    public init(numberFormatter: NumberFormatter, value: Binding<Int>) {
        self.numberFormatter = numberFormatter
        self.currencyField = CurrencyUITextField(formatter: numberFormatter, value: value)
    }
    
    public func makeUIView(context: Context) -> CurrencyUITextField {
        return currencyField
    }
    
    public func updateUIView(_ uiView: CurrencyUITextField, context: Context) {
        
    }
}
