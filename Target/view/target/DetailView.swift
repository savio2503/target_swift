//
//  DetailView.swift
//  target
//
//  Created by Sávio Dutra on 01/01/24.
//

import SwiftUI
import ComponentsCommunication

struct DetailView: View {

    @State var descricao: String = ""
    @State var valor = 0
    @State var msgError: String = ""
    private var target: Target
    @State var deposits: [Deposit] = []
    private var sizeMaxImage: Double = 0.0
    @State var priority: Int
    @State var coin: Int
    @State var source: String
    @State var removedBackground: Bool
    @State private var textMenu = "R$"
    @State private var typeCoin = 1
    @State var urlTarget: String?
    
    var numberFormatter: NumberFormatter
    
    init(target: Target) {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(red: 0.12, green: 0.55, blue: 0.95, alpha: 1.00)

        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance

        self.target = target

        _descricao = State(initialValue: self.target.descricao)
        _coin = State(initialValue: self.target.coin!)

        sizeMaxImage =
            UIScreen.screenWith < UIScreen.screenHeight
            ? UIScreen.screenWith : UIScreen.screenHeight

        sizeMaxImage = sizeMaxImage - 150
        
        self.priority = target.posicao
        
        _valor = State(initialValue: Int(self.target.valor * 100))
        
        _source = State(initialValue: self.target.imagem ?? " ")
        
        _removedBackground = State(initialValue: self.target.removebackground == 1)
        
        _urlTarget = State(initialValue: self.target.url)
        
        self.numberFormatter = NumberFormatter()
        self.numberFormatter.numberStyle = NumberFormatter.Style.currency
        self.numberFormatter.maximumFractionDigits = 2
        
        if (coin == 1) {
            self.numberFormatter.locale = Locale(identifier: "pt_BR")
            _textMenu = State(initialValue: "R$")
            _typeCoin = State(initialValue: 1)
        } else {
            self.numberFormatter.locale = Locale(identifier:  "en_US")
            _textMenu = State(initialValue: "U$")
            _typeCoin = State(initialValue: 2)
        }
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
                        
                        Menu(textMenu) {
                            Button("Real, R$") {
                                textMenu = "R$"
                                typeCoin = 1
                            }
                            Button("Dolar, U$") {
                                textMenu = "U$"
                                typeCoin = 2
                            }
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(.blue.opacity(0.8))
                        .cornerRadius(8.0)
                        
                        CurrencyTextField(numberFormatter: numberFormatter, value: $valor)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(5.0)
                            .keyboardType(.numberPad)
                            .frame(height: 50)

                    }
                    .padding(.horizontal, 16)
                    
                    //MARK: - URL
                    Text("Pagina web do objetivo")
                        .padding(.top, 16)
                    UrlView(urlSource: $urlTarget)
                        .padding(.top, 4)
                    
                    //MARK: - PESO
                    VStack {
                        Text("Selecione o peso do objetivo")

                        PriorityView(selectNumber: self.$priority)
                            .padding(.top, 4)

                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)

                    ButtonEdit(target: Target(id: target.id,
                                              descricao: descricao,
                                              valor: Double(Double(valor) / 100),
                                              posicao: priority,
                                              porcentagem: target.porcentagem,
                                              imagem: source,
                                              coin: typeCoin,
                                              removebackground: removedBackground ? 1 : 0,
                                              comprado: target.comprado,
                                              url: urlTarget),
                               imagemOrigem: self.target.imagem ?? " ")
                        .padding(.top, 20)

                    Divider()
                        .padding(.top, 20)

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
        .onChange(of: typeCoin) {
            self.numberFormatter.locale = Locale(identifier: typeCoin == 1 ? "pt_BR" : "en_US")
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

        let result = (target.valor * (target.porcentagem ?? 0.0)) / 100

        //TODO: Pegar o tipo vai classe depois
        let moeda = target.coin == 1 ? "Real" : "Dolar"
        let tipo = target.coin == 1 ? "R$" : "U$"

        var complement = ""
        
        if deposits.count > 1 && result > 0{
            complement = "\n\(estimative(deposits: deposits, objetivo: Double(valor / 100)))"
        }
        
        return "Total depositado em \(moeda) foi: \(tipo) \(String(format: "%.02f", result))\(complement)"
    }

}

/*#Preview {
    DetailView(target: Target(id: 1, descricao: "teste", valor: 10.5, posicao: 1, ativo: 1, total: 100, porcetagem: 1.25, imagem: " ", coin: 1, removebackground: 0))
}*/

