//
//  LoginResponse.swift
//  target
//
//  Created by Sávio Dutra on 25/12/23.
//

import Foundation

struct LoginResponse: Codable, Hashable {
    let type: String
    let token: String
    let expires_at: String
}
