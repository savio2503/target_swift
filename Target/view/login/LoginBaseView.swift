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
    
    var body: some View {
        #if os(macOS)
        macOSView
        #else
        iOSView
        #endif
    }
    
    #if os(macOS)
    private var macOSView: some View {
        VStack {
            Text("Login")
                .font(.title)
                .padding()
            
            contentView
        }
        .frame(minWidth: 400, minHeight: 400)
        .onAppear(perform: handleLoginState)
    }
    #else
    private var iOSView: some View {
        NavigationStack {
            contentView
                .navigationTitle("Login")
                .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear(perform: handleLoginState)
    }
    #endif
    
    @ViewBuilder
    private var contentView: some View {
        if tipoLogin == 1 {
            LoginView(tipoLogin: $tipoLogin)
        } else if tipoLogin == 2 {
            LoggedView()
        } else if tipoLogin == 3 {
            SignupView()
        }
    }
    
    private func handleLoginState() {
        if (KeysStorage.shared.token ?? "").isEmpty {
            tipoLogin = 1
        } else {
            tipoLogin = 2
        }
    }
}

#Preview {
    LoginBaseView()
}
