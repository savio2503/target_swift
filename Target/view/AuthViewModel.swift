//
//  AuthViewModel.swift
//  target
//
//  Created by Sávio Dutra on 07/05/25.
//

import Foundation

class AuthViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var userName = ""
    @Published var updateTarget = false
    let textPadrao = "Por favor, faça o login"
    
    private init() {
        userName = textPadrao
    }
    
    public static var shared: AuthViewModel = {
        let instance = AuthViewModel()
        return instance
    }()
    
    public func setTextInit() {
        userName = textPadrao
    }
}
