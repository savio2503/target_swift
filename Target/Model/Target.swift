//
//  Target.swift
//  Target
//
//  Created by Sávio Dutra on 12/10/22.
//

import Foundation
import ParseSwift

struct Target: ParseObject {
    var originalData: Data?
    
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    
    var descricao: String?
    var usuario: String?
    var valorFinal: Double?
    var tipoValor: Double?
}
