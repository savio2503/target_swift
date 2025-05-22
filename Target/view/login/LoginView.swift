//
//  LoginView.swift
//  target
//
//  Created by Sávio Dutra on 25/12/23.
//

import SwiftUI
import ComponentsCommunication

struct LoginView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var logging = false
    @State var msgError: String = ""
    @State var logged: Bool = false
    @Environment(\.dismiss) private var dismiss
    @Binding var tipoLogin: Int
    @Environment(\.colorScheme) var colorScheme
    @State var alert = false
    
    #if os(macOS)
    var screen = NSScreen.main?.visibleFrame
    #endif
    
    var body: some View {
        #if os(macOS)
            
        HStack {
            Spacer()
            
            VStack {
                
                Spacer(minLength: 0)
                
                Image("Icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                
                Text("Welcome Back")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                    .padding(.vertical, 10)
                
                Button(action: {}) {
                    HStack {
                        Image("google")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                        
                        Spacer(minLength: 0)
                        
                        Text("Log in with Google")
                            .foregroundColor(.black)
                        
                        Spacer(minLength: 0)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .background(.white)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: -5, y: -5)
                }
                .buttonStyle(PlainButtonStyle())
                .frame(width: screen!.width / 3.6)
                
                HStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(height: 1)
                    
                    Text("OR")
                        .foregroundColor(.gray)
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(height: 1)
                }
                .frame(width: screen!.width / 3.6)
                
                Group {
                    TextField("Email", text: $email)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background(RoundedRectangle(cornerRadius: 2).stroke(.gray.opacity(0.7), lineWidth: 1))
                        .tint(.black)
                        .foregroundColor(.black)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background(RoundedRectangle(cornerRadius: 2).stroke(.gray.opacity(0.7), lineWidth: 1))
                        .padding(.top)
                        .tint(.black)
                        .foregroundColor(.black)
                    
                    Button(action: {}) {
                        Text("Forget Password")
                            .foregroundColor(.black)
                            .underline(true, color: Color.black)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        
                        if (email.isEmpty || password.isEmpty) {
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
                        
                    }) {
                        HStack {
                            Spacer()
                            
                            Text("Login")
                            
                            Spacer()
                            
                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background(.blue)
                        .cornerRadius(2)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.top)
                    
                    HStack {
                        Text("Don't have account yet?")
                            .foregroundColor(.gray)
                        
                        Button(action: {}) {
                            Text("Sign up")
                                .foregroundColor(.blue)
                                .underline(true, color: .black)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.top, 10)
                }
                .frame(width: screen!.width / 3.6)
                
                Spacer(minLength: 0)
                
            }
            
            Spacer()
        }
        .padding(.horizontal, 50)
        .background(.white)
        .ignoresSafeArea(.all, edges: .all)
        .frame(width: screen!.width / 1.8, height: screen!.height - 100)
        .alert(isPresented: $alert) {
            Alert(title: Text("Message"), message: Text("Logged Successfully"), dismissButton: .destructive(Text("OK")))
        }
        #else
        VStack(spacing: 20) {
            VStack (spacing: 8) {
                Image(colorScheme == .dark ? "esqueletoBranco" : "esqueletoPreto")
                    .resizable()
                    .frame(width: 65, height: 50)
                    .foregroundColor(.gray)
                
                HStack(spacing: 4) {
                    Text("Target")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    
                    Text("Account")
                        .font(.title)
                        .foregroundColor(.gray)
                }
            }
            .padding(.top, 40)
            
            Text("Entrar")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
            
            HStack {
                Text("Nao tem uma conta?")
                    .foregroundColor(.gray)
                Button("Inscreva-se") {
                    
                }
                .foregroundColor(.blue)
            }
            
            TextField("Endereço de e-mail", text: $email)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 1)
                )
                .foregroundColor(.white)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
            
            SecureField("Senha", text: $password)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 1)
                )
                .foregroundColor(.white)
                .autocapitalization(.none)
            
            Button(action: {
                
                if (email.isEmpty || password.isEmpty) {
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
                
            }) {
                Text(logging ? "Logando....." : "Login")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(30)
            }
            
            Text(msgError)
                .foregroundStyle(.red)
            
            Button("Esqueceu sua senha?") {
                
            }
            .foregroundColor(.blue)
            .padding(.top, msgError.isEmpty ? -20 : 0)
            
            VStack(spacing: 12) {
                socialButton(icon: "globe", text: "Entrar com Google")
                socialButton(icon: "apple.logo", text: "Entrar com Apple")
            }
            .padding(.top, 10)
            
            Spacer()
        }
        .padding()
        .background(colorScheme == .dark ? Color.black.edgesIgnoringSafeArea(.all) : Color.white.edgesIgnoringSafeArea(.all))
        .onChange(of: email) {
            if !msgError.isEmpty {
                msgError = ""
            }
        }
        .onChange(of: password) {
            if !msgError.isEmpty {
                msgError = ""
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        #endif
    }
    
    func socialButton(icon: String, text: String) -> some View {
        Button(action: {}) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                Text(text)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.gray, lineWidth: 1)
            )
        }
    }
    
    private func login() async {
        
        logging = true
        
        do {
            let response = try await Api.shared.login(userLogin: LoginRequest(email: email, password: password))
            
            if (response != "") {
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

#Preview {
    @Previewable @State var tipoLogin: Int = 1
    LoginView(tipoLogin: $tipoLogin)
}
