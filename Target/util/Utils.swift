//
//  Utils.swift
//  target
//
//  Created by Sávio Dutra on 31/12/23.
//

import Foundation
import SwiftUI

func baseButton(text: String, color: Color) -> any View {
    
    return HStack {
        Spacer()
        Text(text)
            .foregroundStyle(.white)
        Spacer()
    }
    .padding()
    .background(color)
    .cornerRadius(5.0)
}

extension UIScreen {
    static let screenWith = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}
