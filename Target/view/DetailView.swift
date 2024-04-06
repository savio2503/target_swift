//
//  DetailView.swift
//  target
//
//  Created by Sávio Dutra on 01/01/24.
//

import SwiftUI

struct DetailView: View {

    @State var descricao: String = ""
    @State var valor: Double = 0.0
    @State var msgError: String = ""
    private var target: Target
    @State var deposits: [Deposit] = []
    private var sizeMaxImage: Double = 0.0
    @State var priority: Int
    @State var coin: Int
    @State var source: String
    @State var removedBackground: Bool

    init(target: Target) {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(red: 0.12, green: 0.55, blue: 0.95, alpha: 1.00)

        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance

        KeysStorage.shared.recarregar = true

        self.target = target

        _descricao = State(initialValue: self.target.descricao)
        //_valor = State(initialValue: NSDecimalNumber(value: self.target.valor) as Decimal)
        _coin = State(initialValue: self.target.coin!)

        sizeMaxImage =
            UIScreen.screenWith < UIScreen.screenHeight
            ? UIScreen.screenWith : UIScreen.screenHeight

        sizeMaxImage = sizeMaxImage - 150

        self.priority = target.posicao
        
        _valor = State(initialValue: self.target.valor)
        
        _source = State(initialValue: self.target.imagem)
        
        _removedBackground = State(initialValue: self.target.removebackground == 1)
        
        //print("imagem: '\(self.target.imagem)'")
    }

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {

                    //MARK: - IMAGE
                    Button(action: {
                        print("tocou")
                    }) {
                        ImageView(source: $source, removedbackground: $removedBackground, sizeMaxImage: self.sizeMaxImage)
                    }
                    .padding()
                    .padding(.top, 12)

                    //MARK: - DESCRIPTION
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
                    .padding(.horizontal, 20)

                    //MARK: - VALOR
                    HStack {

                        TextField(
                            "Valor", value: $valor,
                            format: .currency(code: coin == 1 ? "BRL" : "USD")
                        )
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(5.0)
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                        .keyboardType(.numberPad)

                    }

                    VStack {
                        Text("Selecione o peso do objetivo")
                            .padding()

                        PriorityView(selectNumber: self.$priority)
                            .padding()

                    }
                    .padding(.horizontal, 20)

                    ButtonEdit(target: Target(id: target.id, descricao: descricao, valor: valor, posicao: priority, imagem: source, removebackground: removedBackground ? 1 : 0))

                    Divider()

                    Text(sumDeposit())
                        .padding(.vertical, 3)

                    Divider()

                    Text("Historico")
                        .padding(.vertical, 3)
                                     
                    DepositsView(deposits: $deposits)
                        .padding(.horizontal)
                }
            }
            .navigationTitle("Editar objetivo")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            Task {
                do {

                    let response = try await Api.shared.getAllDeposity(targetId: self.target.id!)

                    self.deposits.removeAll()

                    self.deposits = response.map { $0 }

                } catch {
                    print("erro deposits: \(error)")
                    msgError = error.localizedDescription
                }
            }
        }
    }

    func sumDeposit() -> String {

        let result = (target.valor * target.porcetagem!) / 100

        //TODO: Pegar o tipo vai classe depois
        var moeda = target.coin == 1 ? "Real" : "Dolar"
        var tipo = target.coin == 1 ? "R$" : "U$"

        return "Total depositado em \(moeda) foi: \(tipo) \(String(format: "%.02f", result))"
    }

}

/*#Preview {
    DetailView(target: Target(id: 1, descricao: "teste", valor: 10.5, posicao: 1, ativo: 1, porcetagem: 1.25, imagem: " ", coin_id: 1))
}*/
