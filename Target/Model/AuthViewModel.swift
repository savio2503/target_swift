//
//  AuthViewModel.swift
//  target
//
//  Created by Sávio Dutra on 25/05/25.
//

import SwiftUI
#if !os(macOS)
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth
#endif

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var userName = ""
    @Published var updateTarget = false
    let textPadrao = "Por favor, faça o login"
    @Published var isBloco = true
    
    #if !os(macOS)
    @Published var user: User?
    private init() {
        self.user = Auth.auth().currentUser
        userName = textPadrao
    }
    #else
    private init() {
        userName = textPadrao
    }
    #endif
    
    public static var shared: AuthViewModel = {
        let instance = AuthViewModel()
        return instance
    }()
    
    
    #if !os(macOS)
    func signInWithGoogle() async throws {
        guard let topVC = await UIApplication.shared.topMostViewController() else {
            throw URLError(.badURL)
        }
        
        let signInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)

        guard let idToken = signInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        
        let accessToken = signInResult.user.accessToken.tokenString

        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

        let result = try await Auth.auth().signIn(with: credential)
        self.user = result.user
    }
    
    public func signOut() {
        GIDSignIn.sharedInstance.signOut()
        try? Auth.auth().signOut()
        self.user = nil
    }
    #endif
    
    public func setTextInit() {
        userName = textPadrao
    }
}
