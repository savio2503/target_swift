//
//  ImageTarget.swift
//  target
//
//  Created by Sávio Dutra on 08/12/24.
//

import Foundation

struct ImageTarget: Codable, Hashable, Identifiable {
    let id: Int?
    let idTarget: Int?
    let updatedAt: String?
    let imagem: String?
}
