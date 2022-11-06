//
//  Debit.swift
//  Target
//
//  Created by Sávio Dutra on 12/10/22.
//

import Foundation
import ParseSwift

struct Debit: ParseObject {
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseSwift.ParseACL?
    
    var valor: Double?
    var target: Target?
    var tipo: Double?
}
