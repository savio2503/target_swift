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
    var imagem: String?
    var coin: Int? = 1
    var removebackground: Int
    var comprado: Int? = 0
    var url: String?
}

extension Target {
    init(from other: Target) {
        self.id = other.id
        self.descricao = other.descricao
        self.valor = other.valor
        self.posicao = other.posicao
        self.ativo = other.ativo
        self.total = other.total
        self.porcetagem = other.porcetagem
        self.imagem = other.imagem
        self.coin = other.coin
        self.removebackground = other.removebackground
        self.comprado = other.comprado
        self.url = other.url
    }
}
