//
//  LoginRequest.swift
//  target
//
//  Created by Sávio Dutra on 25/12/23.
//

import Foundation

public struct LoginRequest : Codable {
    public let email: String
    public let password: String
    
    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
