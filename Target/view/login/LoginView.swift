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
    @State var logged: Bool = false
    @Environment(\.dismiss) private var dismiss
    @Binding var tipoLogin: Int
    
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
                    
                    if (logged) {
                        KeysStorage.shared.recarregar = true
                        dismiss()
                    }
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
            
            Button(action: {
                self.tipoLogin = 3
            }, label: {
                Text("Don't have an account? Click here to register.")
            })
            .padding(.top, 32)
            
            Text(msgError)
                .foregroundStyle(.red)
            
            Spacer()
            
        }
        .padding()
        .onChange(of: username) {
            if !msgError.isEmpty {
                msgError = ""
            }
        }
        .onChange(of: password) {
            if !msgError.isEmpty {
                msgError = ""
            }
        }
    }
    
    private func login() async {
        
        logging = true
        
        do {
            let response = try await Api.shared.login(userLogin: LoginRequest(email: username, password: password))
            
            if (response != "") {
                print("O login retornou positivo")
                
                KeysStorage.shared.token = response
                
                logged = true
            } else {
                msgError = Api.shared.getLastErro()
                print("\(msgError)")
            }
            
        } catch {
            print("\(error)")
            msgError = error.localizedDescription
        }
        
        logging = false
    }
}

/*#Preview {
    LoginView()
}*/
