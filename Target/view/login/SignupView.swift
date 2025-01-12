//
//  signup.swift
//  target
//
//  Created by Sávio Dutra on 25/12/23.
//

import SwiftUI
import ComponentsCommunication

struct SignupView: View {
    
    @State private var email: String = ""
    @State private var password: String  = ""
    @State private var sending: Bool = false
    @State private var logged: Bool = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            ZStack {
                Color("BgColor").edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    Spacer()
                    
                    VStack {
                        
                        Text("Sign in")
                            .font(.largeTitle)
                            .bold()
                            .padding(.bottom, 30)
                        
                        SocalLoginButton(image: Image("apple"), text: Text("Sign in with Apple"))
                        
                        SocalLoginButton(image: Image("google"), text: Text("Sign in with Google"))
                        
                        Text("or get a link emailed to you")
                            .foregroundColor(.gray)
                            .padding(.top, 20)
                        
                        TextField(text: $email) {
                            Text("Enter your email address")
                        }
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(50)
                            .shadow(color: Color.black.opacity(0.2), radius: 30, x: 2, y: 2)
                            .keyboardType(.emailAddress)
                        
                        SecureField("Enter your password", text: $password)
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(50)
                            .shadow(color: Color.black.opacity(0.2), radius: 30, x: 2, y: 2)
                        
                        Button(action: {
                            Task {
                                await signin()
                                
                                if (logged) {
                                    KeysStorage.shared.recarregar = true
                                    dismiss()
                                }
                            }
                        }) {
                            Text(sending ? "Creating" : "Sigin in")
                                .font(.title2)
                                .padding()
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                .background(Color.blue)
                                .cornerRadius(50)
                                .shadow(color: Color.black.opacity(0.2), radius: 30, x:2, y: 2)
                                .foregroundColor(.white)
                        }
                        
                        
                        //Primary
                        
                    }
                    
                    Spacer()
                    
                    Divider()
                    
                    Spacer()
                    
                    Text("You are Completely safe.")
                    Text("Read our Terms & Conditions")
                        .foregroundColor(Color("PrimaryColor"))
                }
            }
            .padding()
        }
    }
    
    private func signin() async {
         
        /*sending = true
        
        do {
            let response = try await Api.shared.signin(userLogin: LoginRequest(email: email, password: password))
            
            KeysStorage.shared.token = response
            
            logged = true
        } catch {
            print("\(error)")
            //msgError = error.localizedDescription
        }
        
        sending = false*/
    }
}

struct SocalLoginButton: View {
    
    var image: Image
    var text: Text
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            image.padding(.horizontal)
            
            Spacer()
            
            text.font(.title3)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(colorScheme == .dark ? Color.gray : Color.white)
        .cornerRadius(50)
        .shadow(color: Color.black.opacity(0.2), radius: 30, x: 2, y: 2)
    }
}

#Preview {
 SignupView()
}
