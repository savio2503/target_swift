//
//  LoginView.swift
//  target
//
//  Created by Sávio Dutra on 25/12/23.
//

import SwiftUI

struct LoginView: View {
    
    @State var username: String = ""
    @State var password: String = ""
    @State var logging = false
    @State var msgError: String = ""
    
    var body: some View {
        VStack(spacing: 10) {
            
            TextField("Username", text: $username, onEditingChanged: { changed in
                msgError = ""
            })
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(5.0)
                .padding(.top, 20)
                .keyboardType(.emailAddress)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(5.0)
            
            Button(action: {
                
                if (username.isEmpty || password.isEmpty) {
                    msgError = "O Usuario/Senha deve ser Preenchido"
                    return
                }
                
                Task {
                    await login()
                }
                
            }, label: {
                HStack {
                    Spacer()
                    Text(logging ? "Logando....." : "Login")
                        .foregroundStyle(.white)
                    Spacer()
                }
                .padding()
                .background(Color.blue)
                .cornerRadius(5.0)
            })
            
            Button(action: {}, label: {
                Text("Forgot Password?")
            })
            
            Text(msgError)
                .foregroundStyle(.red)
            
            Spacer()
            
        }.padding()
    }
    
    private func login() async {
        
        logging = true
        
        do {
            let response = try await Api.shared.login(userLogin: LoginRequest(email: username, password: password))
            
            print("O login retornou positivo")
            
            KeysStorage.shared.token = response.token
            
        } catch {
            print("\(error)")
            msgError = error.localizedDescription
        }
        
        logging = false
    }
}

#Preview {
    LoginView()
}
