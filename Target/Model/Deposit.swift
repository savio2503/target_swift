//
//  Deposit.swift
//  target
//
//  Created by Sávio Dutra on 02/01/24.
//

import Foundation

struct Deposit: Codable, Hashable, Identifiable {
    
    let id: Int?
    let valor: Double
    let mes: String
    
}
