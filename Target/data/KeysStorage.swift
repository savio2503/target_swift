//
//  KeysStorage.swift
//  target
//
//  Created by Sávio Dutra on 25/12/23.
//

import Foundation

class KeysStorage {
    
    var _token: String?
    var token: String? {
        get {
            return _token
        }
        set (value) {
            defaults.set(value, forKey: "token")
            _token = value
        }
    }
    
    var _recarregar: Bool = false
    var recarregar: Bool {
        get {
            return _recarregar
        }
        set (value) {
            _recarregar = value
        }
    }
    
    private let defaults = UserDefaults.standard
    
    static var shared: KeysStorage = {
        let instance = KeysStorage()
        return instance
    }()
    
    private init() {
        load()
    }
    
    private func load() {
        token = defaults.string(forKey: "token")
    }
}
