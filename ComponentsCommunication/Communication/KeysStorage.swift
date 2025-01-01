//
//  KeysStorage.swift
//  target
//
//  Created by Sávio Dutra on 25/12/23.
//

import Foundation

public class KeysStorage {
    
    private var _token: String?
    public var token: String? {
        get {
            return _token
        }
        set (value) {
            sharedDefaults.set(value, forKey: "token")
            _token = value
        }
    }
    
    private var _recarregar: Bool = false
    public var recarregar: Bool {
        get {
            return _recarregar
        }
        set (value) {
            _recarregar = value
        }
    }
    
    private let sharedDefaults: UserDefaults
    
    public static var shared: KeysStorage = {
        let instance = KeysStorage()
        return instance
    }()
    
    private init() {
        // Inicializa com App Group UserDefaults
        guard let defaults = UserDefaults(suiteName: "group.br.com.savio2503.target") else {
            fatalError("App Group não configurado corretamente.")
        }
        self.sharedDefaults = defaults

        // Carrega valores persistidos
        load()
    }
    
    private func load() {
        token = sharedDefaults.string(forKey: "token")
    }
}
