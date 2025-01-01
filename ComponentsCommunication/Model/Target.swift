//
//  TaskModel.swift
//  target
//
//  Created by Sávio Dutra on 01/01/24.
//

import Foundation

public struct Target: Codable, Hashable, Identifiable {
    
    public let id: Int?
    public var descricao: String
    public var valor: Double
    public var posicao: Int
    public var ativo: Int? = 1
    public var total: Double?
    public var porcentagem: Double? = 0.0
    public var imagem: String?
    public var coin: Int? = 1
    public var removebackground: Int
    public var comprado: Int? = 0
    public var url: String?

    // Initializer (if needed)
    public init(id: Int? = nil,
                descricao: String,
                valor: Double,
                posicao: Int,
                ativo: Int? = 1,
                total: Double? = nil,
                porcentagem: Double? = nil,
                imagem: String? = nil,
                coin: Int? = 1,
                removebackground: Int,
                comprado: Int? = 0,
                url: String? = nil) {
        self.id = id
        self.descricao = descricao
        self.valor = valor
        self.posicao = posicao
        self.ativo = ativo
        self.total = total
        self.porcentagem = porcentagem
        self.imagem = imagem
        self.coin = coin
        self.removebackground = removebackground
        self.comprado = comprado
        self.url = url
    }
    
    public init(from other: Target) {
        self.id = other.id
        self.descricao = other.descricao
        self.valor = other.valor
        self.posicao = other.posicao
        self.ativo = other.ativo
        self.total = other.total
        self.porcentagem = other.porcentagem
        self.imagem = other.imagem
        self.coin = other.coin
        self.removebackground = other.removebackground
        self.comprado = other.comprado
        self.url = other.url
    }
}

/*public extension Target {
    
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
}*/
