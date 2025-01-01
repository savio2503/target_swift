//
//  Deposit.swift
//  target
//
//  Created by Sávio Dutra on 02/01/24.
//

import Foundation

public struct Deposit: Codable, Hashable, Identifiable {
    
    public var id: Int?
    public let valor: Double
    public let mes: String
    
    public init(id: Int? = nil, valor: Double, mes: String) {
        self.id = id
        self.valor = valor
        self.mes = mes
    }
    
}
