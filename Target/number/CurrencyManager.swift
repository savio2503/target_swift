//
//  CurrencyManager.swift
//  target
//
//  Created by Sávio Dutra on 11/02/24.
//

import Foundation

class CurrencyManager: ObservableObject {
    
    @Published var string: String = ""
    private let formatter = NumberFormatter(numberStyle: .currency)
    private var maximum: Decimal = 99_999_999_999.99
    private var lastValue: String = ""
    
    init(amount: Decimal, maximum: Decimal = 99_999_999_999.99, locale: Locale = .current) {
        formatter.locale = locale
        self.string = formatter.string(for: amount) ?? "$0.00"
        self.lastValue = string
        self.maximum = maximum
    }
    
    func valueChanged(value: String) {
        let newValue = (value.decimal ?? .zero) / pow(10, formatter.maximumFractionDigits)
        if newValue > maximum {
            string = lastValue
        } else {
            string = formatter.string(for: newValue) ?? "$0.00"
            lastValue = string
        }
    }
    
    func localeChange(locale: Locale) {
        formatter.locale = locale
        valueChanged(value: lastValue)
    }
    
    func getDouble() -> Double {
        
        var res: Double = 0.0
        
        res = ((lastValue.decimal ?? .zero) / pow(10, formatter.maximumFractionDigits)).doubleValue
        
        return res
    }
}

extension NumberFormatter {
    convenience init(numberStyle: Style, locale: Locale = .current) {
        self.init()
        self.locale = locale
        self.numberStyle = numberStyle
    }
}

extension Character {
    var isDigit: Bool { "0"..."9" ~= self }
}

extension LosslessStringConvertible {
    var string: String { .init(self) }
}

extension StringProtocol where Self: RangeReplaceableCollection {
    var digits: Self { filter (\.isDigit) }
    var decimal: Decimal? { Decimal(string: digits.string) }
}

extension Decimal {
    var doubleValue: Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }
}
