//
//  User.swift
//  target
//
//  Created by Sávio Dutra on 25/12/23.
//

import Foundation

public struct User: Identifiable {
    public let id: Int
    public var name: String
    public var score: Int
    
    public init(id: Int, name: String, score: Int) {
        self.id = id
        self.name = name
        self.score = score
    }
}
