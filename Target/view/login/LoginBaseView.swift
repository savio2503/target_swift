//
//  LoginBaseView.swift
//  target
//
//  Created by Sávio Dutra on 25/12/23.
//

import SwiftUI
import ComponentsCommunication

struct LoginBaseView: View {
    
    @State private var tipoLogin = 1
    
    init() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(red: 0.12, green: 0.55, blue: 0.95, alpha: 1.00)
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        let backItemAppearance = UIBarButtonItemAppearance()
        backItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navBarAppearance.backButtonAppearance = backItemAppearance
        
        let image = UIImage(systemName: "chevron.backward")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        
        navBarAppearance.setBackIndicatorImage(image, transitionMaskImage: image)
        
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if (tipoLogin == 1) {
                    LoginView(tipoLogin: $tipoLogin)
                } else if (tipoLogin == 2) {
                    LoggedView()
                } else if (tipoLogin == 3) {
                    SignupView()
                }
            }
            .navigationTitle("Login")
            .navigationBarTitleDisplayMode(.inline)
        }.onAppear {
            
            
            if (KeysStorage.shared.token ?? "").isEmpty {
                tipoLogin = 1
            } else {
                tipoLogin = 2
            }
            
            //print("token: \(KeysStorage.shared.token ?? "null"), tipo: \(tipoLogin)")
        }
    }
}
