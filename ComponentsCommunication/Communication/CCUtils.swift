//
//  Utils.swift
//  ComponentsCommunication
//
//  Created by Sávio Dutra on 26/12/24.
//

import Foundation


extension URLResponse {
    func headerField(forKey key: String) -> String? {
        (self as? HTTPURLResponse)?.allHeaderFields[key] as? String
    }
}
