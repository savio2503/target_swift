//
//  DetailView.swift
//  target
//
//  Created by Sávio Dutra on 01/01/24.
//

#if os(macOS)
import AppKit
#endif
import SwiftUI
import ComponentsCommunication

struct DetailView: View {
    
    private var target: Target
    @State var descricao: String = ""
    @State var valor = 0
    @State var msgError: String = ""
    @State var deposits: [Deposit] = []
    private var sizeMaxImage: Double = 0.0
    @State var priority: Int
    @State var coin: Int
    @State var source: String
    @State var removedBackground: Bool
    @State private var textMenu = "R$"
    @State private var typeCoin = 1
    @State var urlTarget: String?
    @Environment(\.colorScheme) var colorScheme
    var tintColor: Color {
        colorScheme == .dark ? Color.white : Color.black
    }
    
    var numberFormatter: NumberFormatter
    @Binding var sheetIsPresented: Bool
    
    init(target: Target, sheetIsPresented: Binding<Bool>) {

        self.target = target
        _sheetIsPresented = sheetIsPresented
        
        print("Detail -> \(target.descricao)")
        _descricao = State(initialValue: self.target.descricao)
        _coin = State(initialValue: self.target.coin!)

        #if os(macOS)
        let screenSize = NSScreen.main?.frame.size ?? .zero
        let _sizeMaxImage = min(screenSize.width, screenSize.height)
        #else
        let screenSize = UIScreen.main.bounds.size
        let _sizeMaxImage = min(screenSize.width, screenSize.height)
        #endif
        sizeMaxImage = _sizeMaxImage - 150

        self.priority = target.posicao
        _valor = State(initialValue: Int(self.target.valor * 100))
        _source = State(initialValue: self.target.imagem ?? " ")
        _removedBackground = State(initialValue: self.target.removebackground == 1)
        _urlTarget = State(initialValue: self.target.url)

        self.numberFormatter = NumberFormatter()
        self.numberFormatter.numberStyle = .currency
        self.numberFormatter.maximumFractionDigits = 2

        if coin == 1 {
            self.numberFormatter.locale = Locale(identifier: "pt_BR")
            _textMenu = State(initialValue: "R$")
            _typeCoin = State(initialValue: 1)
        } else {
            self.numberFormatter.locale = Locale(identifier: "en_US")
            _textMenu = State(initialValue: "U$")
            _typeCoin = State(initialValue: 2)
        }
    }

    var body: some View {
        NavigationStack {
            content
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
                    
                    updatesImagem()

                } catch {
                    print("erro deposits: \(error)")
                    msgError = error.localizedDescription
                }
            }
        }
    }
    
    #if os(macOS)
    private var content: some View {
        
        HStack{
            //MARK: - IMAGE
            Button(action: {}) {
                ImageView(source: $source, removedbackground: $removedBackground, sizeMaxImage: self.sizeMaxImage)
            }
            .padding()
            .buttonStyle(BorderlessButtonStyle())
            .padding(.top, 12)
            .frame(minWidth: 250)
            
            //MARK: - EDICAO
            VStack {

                //MARK: - DESCRIPTION
                TextField(
                    "Descrição", text: $descricao,
                    onEditingChanged: { changed in
                        msgError = ""
                    }
                )
                .padding()
                .textFieldStyle(PlainTextFieldStyle())
                .background(Color.gray.opacity(0.3))
                .tint(tintColor)
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
                    .buttonStyle(BorderlessButtonStyle())
                    .foregroundColor(.white)
                    .background(.blue.opacity(0.8))
                    .cornerRadius(8.0)
                    .frame(maxWidth: 100)
                    
                    //#if !os(macOS)
                    CurrencyTextField(numberFormatter: numberFormatter, value: $valor)
                        .padding()
                        .background(Color.gray.opacity(0.3))
                        .tint(tintColor)
                        .cornerRadius(5.0)
                        .frame(height: 50)
                    //#endif

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
                                          ativo: target.ativo,
                                          total: target.total,
                                          porcentagem: target.porcentagem,
                                          imagem: source,
                                          coin: typeCoin,
                                          removebackground: removedBackground ? 1 : 0,
                                          comprado: target.comprado,
                                          url: urlTarget),
                           imagemOrigem: self.target.imagem ?? " ",
                           sheetIsPresented: $sheetIsPresented)
                    .padding(.top, 20)
            }
            .frame(minWidth: 350)
            
            //MARK: - HISTORIC
            ScrollView {

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
            .scrollIndicators(.hidden)
            .frame(minWidth: 300)
        }
        .navigationTitle("Editar objetivo")
        .frame(minWidth: 1000, idealHeight: 450)
    }
    #else
    private var content: some View {
        VStack {
            ScrollView {

                //MARK: - IMAGE
                Button(action: {}) {
                    ImageView(source: $source, removedbackground: $removedBackground, sizeMaxImage: self.sizeMaxImage)
                }
                .padding()
                .buttonStyle(BorderlessButtonStyle())
                .padding(.top, 12)

                //MARK: - DESCRIPTION
                TextField(
                    "Descrição", text: $descricao,
                    onEditingChanged: { changed in
                        msgError = ""
                    }
                )
                .padding()
                .textFieldStyle(PlainTextFieldStyle())
                .background(Color.gray.opacity(0.3))
                .tint(tintColor)
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
                    .buttonStyle(BorderlessButtonStyle())
                    .foregroundColor(.white)
                    .background(.blue.opacity(0.8))
                    .cornerRadius(8.0)
                    #if os(macOS)
                    .frame(maxWidth: 100)
                    #endif
                    
                    //#if !os(macOS)
                    CurrencyTextField(numberFormatter: numberFormatter, value: $valor)
                        .padding()
                        .background(Color.gray.opacity(0.3))
                        .tint(tintColor)
                        .cornerRadius(5.0)
                    #if !os(macOS)
                        .keyboardType(.numberPad)
                    #endif
                        .frame(height: 50)
                    //#endif

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
                                          ativo: target.ativo,
                                          total: target.total,
                                          porcentagem: target.porcentagem,
                                          imagem: source,
                                          coin: typeCoin,
                                          removebackground: removedBackground ? 1 : 0,
                                          comprado: target.comprado,
                                          url: urlTarget),
                           imagemOrigem: self.target.imagem ?? " ",
                           sheetIsPresented: $sheetIsPresented)
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
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Editar objetivo")
        #if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .frame(maxWidth: 650)
        .onTapGesture {
            hideKeyboard()
        }
    }
    #endif

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
    
    func updatesImagem() {
        Task {
            if source != " " {
                //print("antes: \(source.count)")
                do {
                    let image = try await Api.shared.getImage(idTarget: target.id!)
                    
                    DispatchQueue.main.async {
                        self.source = image.imagem ?? " "
                        //print("depois: \(source.count)")
                    }
                }catch {
                    print("erro ao update imagem em detail: \(error)")
                }
            }
        }
    }

}

/*#Preview {
    DetailView(target: Target(id: 1, descricao: "Teste Padrao", valor: 200.0, posicao: 5, porcentagem: 0.0, imagem: "https://colorindonuvens.com/wp-content/uploads/2018/12/Wallpaper4k-cidade-Colorindonuvens-5.jpg", removebackground: 0))
}*/

