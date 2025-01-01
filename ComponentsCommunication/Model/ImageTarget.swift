//
//  ImageTarget.swift
//  target
//
//  Created by Sávio Dutra on 08/12/24.
//

import Foundation

public struct ImageTarget: Codable, Hashable, Identifiable {
    public let id: Int?
    public let idTarget: Int?
    public let updatedAt: String?
    public let imagem: String?
    
    public init(id: Int?, idTarget: Int?, updatedAt: String?, imagem: String?) {
        self.id = id
        self.idTarget = idTarget
        self.updatedAt = updatedAt
        self.imagem = imagem
    }
}
