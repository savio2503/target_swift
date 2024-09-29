//
//  ErrorResponse.swift
//  target
//
//  Created by Sávio Dutra on 26/09/24.
//

import SwiftUI

struct ErrorResponse: Codable {
    let errors: [ErrorDetail]
}

struct ErrorDetail: Codable {
    let message: String
}
