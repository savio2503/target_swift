//
//  User.swift
//  Target
//
//  Created by Sávio Dutra on 03/10/22.
//

import Foundation
import ParseSwift

struct User: ParseUser {
    var authData: [String : [String : String]?]?
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    
    var username: String?
    var email: String?
    var emailVerified: Bool?
    var password: String?
}
