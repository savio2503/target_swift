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
    private var target: Target
    @State var deposits: [Deposit] = []

    init(target: Target) {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(red: 0.12, green: 0.55, blue: 0.95, alpha: 1.00)

        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance

        KeysStorage.shared.recarregar = true

        self.target = target

        _descricao = State(initialValue: self.target.descricao)
        _valor = State(initialValue: String(format: "%.02f", self.target.valor))
    }

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    
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

                    TextField(
                        "Descrição", text: $descricao,
                        onEditingChanged: { changed in
                            msgError = ""
                        }
                    )
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.top, 20)
                    .keyboardType(.emailAddress)

                    HStack {

                        TextField(
                            "Valor", text: $valor,
                            onEditingChanged: { changed in
                                msgError = ""
                            }
                        )
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
                                    .foregroundStyle(.blue)
                                    .padding(.horizontal, 10)
                            }
                            .padding()
                            .background(Color("CardColor"))
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
                            .background(Color("CardColor"))
                            .cornerRadius(30.0)
                        }
                        .padding()

                        Spacer()
                    }

                    Divider()

                    Text(sumDeposit())
                        .padding(.vertical, 3)

                    Divider()

                    Text("Historico")
                        .padding(.vertical, 3)

                    ForEach(deposits, id: \.self) { deposit in
                        
                        if deposit.valor != 0.0 {
                            
                            HStack {
                                Spacer()
                                Text("\(String(format: "R$ %.02f", deposit.valor))")
                                Spacer()
                                Text("\(dateFormat(text: deposit.created_at))")
                            }
                            Divider()
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Editar objetivo")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            Task {
                do {

                    let response = try await Api.shared.getAllDeposity(targetId: self.target.id)

                    self.deposits.removeAll()

                    self.deposits = response.map { $0 }

                    print("historic: \(self.deposits)")

                } catch {
                    print("erro deposits: \(error)")
                    msgError = error.localizedDescription
                }
            }
        }
    }
    
    func sumDeposit() -> String {
        
        let result = (target.valor * target.porcetagem) / 100
        
        
        return "Total depositado em X foi: R$ \(result)"
    }
}

/*#Preview {
    DetailView(target: Target(id: 1, descricao: "teste", valor: 10.5, posicao: 1, ativo: 1, porcetagem: 1.25, imagem: " ", coin_id: 1))
}*/
