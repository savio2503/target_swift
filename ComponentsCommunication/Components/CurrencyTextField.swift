//
//  CurrencyTextField.swift
//  target
//
//  Created by Sávio Dutra on 05/07/24.
//

import SwiftUI

#if os(macOS)
public struct CurrencyTextField: NSViewRepresentable {
    
    public typealias NSViewType = CurrencyNSTextField
    
    let numberFormatter: NumberFormatter
    @Binding var value: Int
    
    public init(numberFormatter: NumberFormatter, value: Binding<Int>)
    {
        self.numberFormatter = numberFormatter
        self._value = value
    }
    
    public func makeNSView(context: Context) -> CurrencyNSTextField {
        return CurrencyNSTextField(formatter: numberFormatter, value: $value)
    }
    
    public func updateNSView(_ nsView: CurrencyNSTextField, context: Context) {
        let expected = numberFormatter.string(from: NSNumber(value: Double(value) / 100.0)) ?? ""
        if nsView.stringValue != expected {
            nsView.stringValue = expected
        }
    }
}
#else

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
#endif
