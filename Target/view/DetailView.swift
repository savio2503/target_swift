//
//  DetailView.swift
//  target
//
//  Created by Sávio Dutra on 01/01/24.
//

import SwiftUI

struct DetailView: View {
    
    @State var descricao: String = ""
    @State var valor: String = ""
    @State var msgError: String = ""
    
    init() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(red: 0.12, green: 0.55, blue: 0.95, alpha: 1.00)
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        
        KeysStorage.shared.recarregar = true
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    print("tocou")
                }) {
                    HStack {
                        Text("Adicionar uma imagem")
                            .foregroundStyle(.white)
                            .padding(.horizontal, 10)
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(30.0)
                }
                .padding()
                
                TextField("Descrição", text: $descricao, onEditingChanged: { changed in
                    msgError = ""
                })
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.top, 20)
                    .keyboardType(.emailAddress)
                
                HStack {
                    
                    TextField("Valor", text: $valor, onEditingChanged: { changed in
                        msgError = ""
                    })
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(5.0)
                        .padding(.top, 20)
                        .keyboardType(.emailAddress)
                    
                }
                
                Text("Selecione o peso do objetivo")
                    .padding()
                
                //pesos
                
                HStack {
                    
                    Spacer()
                    
                    Button(action: {
                        print("tocou")
                    }) {
                        HStack {
                            Text("Salvar")
                                .foregroundStyle(.white)
                                .padding(.horizontal, 10)
                        }
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(30.0)
                    }
                    .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        print("tocou")
                    }) {
                        HStack {
                            Text("Excluir")
                                .foregroundStyle(.red)
                                .padding(.horizontal, 10)
                        }
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(30.0)
                    }
                    .padding()
                    
                    Spacer()
                }
                
                Divider()
                
                Text("Total depositado em X foi: Y")
                    .padding(.vertical, 3)
                
                Divider()
                
                Text("Historico")
                    .padding(.vertical, 3)
            }
            .navigationTitle("Editar objetivo")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    DetailView()
}
