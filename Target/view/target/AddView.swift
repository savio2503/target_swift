//
//  AddView.swift
//  target
//
//  Created by Sávio Dutra on 12/01/24.
//

#if os(macOS)
import AppKit
#endif
import SwiftUI
import PhotosUI
import ComponentsCommunication

struct AddView: View {
    @State var descricao: String = ""
    @State var valor = 0
    @State var prioridade: Int = 1
    @State private var textMenu = "R$"
    @State private var typeCoin = 1
    private var sizeMaxImage: Double = 0.0
    @State private var error = ""
    @State private var loading = false
    @State private var sendSucesso = false
    @State var source: String = " "
    @State var removedBackground: Bool = false
    @Environment(\.dismiss) private var dismiss
    @State var numberFormatter: NumberFormatter
    @State var urlTarget: String? = nil
    @Environment(\.colorScheme) var colorScheme
    var tintColor: Color {
        colorScheme == .dark ? Color.white : Color.black
    }
    @Binding var sheetIsPresented: Bool
    
    init(sheetIsPresented: Binding<Bool>) {
        
        _sheetIsPresented = sheetIsPresented
        
        self.numberFormatter = NumberFormatter()
        self.numberFormatter.numberStyle = .currency
        self.numberFormatter.maximumFractionDigits = 2
        self.numberFormatter.locale = Locale(identifier: "pt_BR")
        
        #if os(macOS)
        let screenSize = NSScreen.main?.frame.size ?? .zero
        let _sizeMaxImage = min(screenSize.width, screenSize.height)
        #else
        let screenSize = UIScreen.main.bounds.size
        let _sizeMaxImage = min(screenSize.width, screenSize.height)
        #endif

        sizeMaxImage = _sizeMaxImage - 150
    }
    
    var body: some View {
        NavigationStack {
            content
        } //: NavigationStack
        .onChange(of: typeCoin) {
            self.numberFormatter.locale = Locale(identifier: typeCoin == 1 ? "pt_BR" : "en_US")
        }
    }
    
    
    #if os(macOS)
    private var content: some View {
        HStack {
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
                TextField("Descrição", text: $descricao)
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

                    PriorityView(selectNumber: self.$prioridade)
                        .padding(.top, 4)

                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                Button(action: {
                    if descricao.isEmpty || valor == 0 {
                        error = "O campo de descrição ou o campo de valor estâo vazios"
                    } else {
                        loading = true
                        Task {
                            await addTarget()
                            if sendSucesso {
                                KeysStorage.shared.recarregar = true
                                dismiss()
                                sheetIsPresented = false
                            }
                        }
                    }
                }) {
                    Text(loading == false ? "Adicionar" : "Enviando...")
                        .foregroundStyle(.white)
                        .padding()
                        .background(Color.blue.opacity(0.85))
                        .cornerRadius(5.0)
                } // MARK: - ENVIAR
                .padding(.top, 32)
                .buttonStyle(BorderlessButtonStyle())
            }
            .frame(minWidth: 350)
            
        }
        .navigationTitle("Criar objetivo")
        .frame(minWidth: 700, minHeight: 450)
    }
    #else
    private var content: some View {
        VStack {
            ScrollView {
                Button(action: {}) {
                    ImageView(source: $source, removedbackground: $removedBackground, sizeMaxImage: self.sizeMaxImage)
                }
                .padding()
                .padding(.top, 12)
                // MARK: - END IMAGEM
                
                TextField("Descricao", text: $descricao)
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .tint(tintColor)
                    .cornerRadius(5.0)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)// MARK: - DESCRICAO
                
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
                        .background(Color.gray.opacity(0.3))
                        .tint(tintColor)
                        .cornerRadius(5.0)
                        .keyboardType(.numberPad)
                        .frame(height: 50)
                } // MARK: - CAMPOS VALOR
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                //MARK: - URL
                Text("Pagina web do objetivo")
                    .padding(.top, 16)
                UrlView(urlSource: $urlTarget)
                    .padding(.top, 4)
                
                Text("Selecione o peso do objetivo")
                    .padding(.top, 32)
                
                PriorityView(selectNumber: self.$prioridade)
                    .padding()
                // MARK: - END CAMPO PRIORIDADE
                
                //Spacer()
                
                if !error.isEmpty {
                    Text(error)
                        .foregroundStyle(.red)
                        .padding(.top, 16)
                }
                
                Button(action: {
                    if descricao.isEmpty || valor == 0 {
                        error = "O campo de descrição ou o campo de valor estâo vazios"
                    } else {
                        loading = true
                        Task {
                            await addTarget()
                            if sendSucesso {
                                KeysStorage.shared.recarregar = true
                                dismiss()
                            }
                        }
                    }
                }) {
                    Text(loading == false ? "Adicionar" : "Enviando...")
                        .foregroundStyle(.white)
                        .padding()
                        .background(Color.blue.opacity(0.85))
                        .cornerRadius(5.0)
                } // MARK: - ENVIAR
                .padding(.top, 32)
            }
        } //: VSTACK
        .navigationTitle("Add a new Target")
        #if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .frame(maxWidth: 650)
        .onChange(of: typeCoin) { _, _ in
            self.numberFormatter.locale = Locale(identifier: typeCoin == 1 ? "pt_BR" : "en_US")
        }
        .onChange(of: descricao) { _, _ in
            error = ""
        }
        .onChange(of: valor) { _, _ in
            error = ""
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
    #endif
    // MARK: - FUNCAO ENVIAR
    func addTarget() async {
        let _value = Double(self.valor) / 100.0
        let target = Target(id: nil,
                            descricao: self.descricao,
                            valor: _value,
                            posicao: self.prioridade,
                            imagem: self.source,
                            coin: self.typeCoin,
                            removebackground: self.removedBackground ? 1 : 0,
                            comprado: 0,
                            url: urlTarget)
        
        do {
            let _ = try await Api.shared.addTarget(target: target)
            sendSucesso = true
        } catch {
            print(error.localizedDescription)
            self.error = error.localizedDescription
        }
        loading = false
    }
}
