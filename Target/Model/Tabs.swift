//
//  Tabs.swift
//  target
//
//  Created by Sávio Dutra on 02/03/25.
//

import SwiftUI

enum Tabs: Equatable, Hashable, Identifiable {
    case progress
    case complete
    
    var id: Int {
        switch self {
        case .progress: 2001
        case .complete: 2002
        }
    }
    
    var name: String {
        switch self {
        case .progress: String(localized: "Progress", comment: "Target in progress")
        case .complete: String(localized: "Complete", comment: "Target completed")
        }
    }
    
    var customizationID: String {
        return "br.com.savio2503.target." + self.name
    }
    
    var symbol: String {
        switch self {
        case .progress: "figure.run"
        case .complete: "target"
        }
    }
    
    var isSecondary: Bool {
        switch self {
        case .progress, .complete: false
        default: true
        }
    }
}
