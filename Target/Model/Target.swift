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
    var ativo: Int? = 1
    var total_deposit: Double?
    var porcetagem: Double?
    let imagem: String
    var coin_id: Int? = 1
}
