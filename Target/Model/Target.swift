//
//  TaskModel.swift
//  target
//
//  Created by Sávio Dutra on 01/01/24.
//

import Foundation

struct Target: Codable, Hashable {
    
    let id: Int
    let descricao: String
    let valor: Double
    let posicao: Int
    let ativo: Int
    var total_deposit: Double?
    var porcetagem: Double
    let imagem: String
    let coin_id: Int?
}
