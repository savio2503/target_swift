//
//  CurrencyNSTextField.swift
//  ComponentsCommunication
//
//  Created by Sávio Dutra on 10/05/25.
//

#if os(macOS)
import SwiftUI
import AppKit

public class CurrencyNSTextField: NSTextField, NSTextFieldDelegate {

    @Binding private var value: Int
    private let numberFormatter: NumberFormatter

    init(formatter: NumberFormatter, value: Binding<Int>) {
        self.numberFormatter = formatter
        self._value = value
        super.init(frame: .zero)

        delegate = self
        drawsBackground = true
        isBezeled = true
        isEditable = true
        isSelectable = true
        font = NSFont.systemFont(ofSize: 18)
        alignment = .left
        focusRingType = .none
        bezelStyle = .roundedBezel

        let doubleaux = self.value
        stringValue = formatter.string(from: NSNumber(value: Double(doubleaux) / 100.0)) ?? ""
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func controlTextDidChange(_ obj: Notification) {
        let text = stringValue.digits
        let decimalValue = (Decimal(string: text) ?? 0) / pow(10, numberFormatter.maximumFractionDigits)
        stringValue = numberFormatter.string(from: NSDecimalNumber(decimal: decimalValue)) ?? ""
        value = Int((decimalValue * 100).doubleValue)
    }
    
    public override func textShouldBeginEditing(_ textObject: NSText) -> Bool {
        return true
    }

    public override func textShouldEndEditing(_ textObject: NSText) -> Bool {
        return true
    }
    
    public override func keyDown(with event: NSEvent) {
        guard let characters = event.characters else { return }

        // Apenas números e teclas de controle (como Delete, Tab, etc.)
        let allowed = CharacterSet.decimalDigits
        if characters.unicodeScalars.allSatisfy({ allowed.contains($0) }) || event.isAControlKey {
            super.keyDown(with: event)
        }
        // Caso contrário, ignora a entrada
    }
}

extension NSEvent {
    var isAControlKey: Bool {
        return keyCode == 51 || keyCode == 117 || keyCode == 48 || keyCode == 36 // delete, forward delete, tab, return
    }
}

extension Decimal {
    var doubleValue: Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }
}
#endif
