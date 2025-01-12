//
//  ExtensionsTools.swift
//  Target
//
//  Created by Sávio Dutra on 07/01/25.
//

import Foundation
import SwiftUI

public extension View {
    func hideKeyboard() {
        #if os(iOS)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        #endif
    }
}
