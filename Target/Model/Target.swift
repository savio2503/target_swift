//
//  TaskModel.swift
//  target
//
//  Created by Sávio Dutra on 01/01/24.
//

import Foundation

struct Target: Codable, Hashable, Identifiable {
    
    let id: Int?
    let descricao: String
    let valor: Double
    let posicao: Int
    var ativo: Int? = 1
    var total: Double?
    var porcetagem: Double?
    var imagem: String
    var coin: Int? = 1
    var removebackground: Int
}
