//
//  AddView.swift
//  target
//
//  Created by Sávio Dutra on 12/01/24.
//

import SwiftUI
import PhotosUI

struct AddView: View {
    @State var descricao: String = ""
    @State var valor: Double = 0.0
    @State var prioridade: Int = 1
    @State private var textMenu = "R$"
    @State private var typeCoin = 1
    @State private var error = ""
    @State private var loading = false
    @State private var sendSucesso = false
    @State var source: String = " "
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject private var currencyManager = CurrencyManager(
        amount: 0,
        locale: .init(identifier: "pt_BR")
    )
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                
                Button(action: {
                    print("tocou")
                }) {
                    ImageView(source: $source, sizeMaxImage: 300)
                }
                .padding()
                .padding(.top, 12)
                //MARK: - END IMAGEM
                
                
                
                TextField("Descricao", text: $descricao)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.horizontal, 16) //MARK: - DESCRICAO
                
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
                    
                    //TextField("Valor", value: $valor, format: .currency(code: typeCoin == 1 ? "BRL" : "USD"))
                    TextField(currencyManager.string, text: $currencyManager.string)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(5.0)
                        .keyboardType(.numberPad)
                        .onChange(of: currencyManager.string ) { value in
                            currencyManager.valueChanged(value: value)
                        }
                }//MARK: - CAMPOS VALOR
                .padding(.horizontal, 16)
                
                
                
                Text("Selecione o peso do objetivo")
                    .padding()
                
                PriorityView(selectNumber: self.$prioridade)
                    .padding()
                //MARK: - END CAMPO PRIORIDADE
                
                Spacer()
                
                if !error.isEmpty {
                    Text(error)
                        .foregroundStyle(.red)
                }
                
                Button(action: {
                    
                    if descricao.isEmpty || self.currencyManager.getDouble() == 0.0 {
                        error = "O campo de descrição ou o campo de valor estâo vazios"
                    } else {
                        loading = true
                        Task {
                            await addTarget()
                            
                            if (sendSucesso) {
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
                    
                }//MARK: - ENVIAR
                .padding(.bottom, 8)
                
                
            }//: VSTACK
            .navigationTitle("Add a new Target")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: descricao) {
                error = ""
            }
            .onChange(of: valor) {
                error = ""
            }
            .onChange(of: typeCoin) {
                switch typeCoin {
                case 1:
                    self.currencyManager.localeChange(locale: .init(identifier: "pt_BR"))
                case 2:
                    self.currencyManager.localeChange(locale: .init(identifier: "en_US"))
                default:
                    print("default")
                }
            }
        }//: NavigationStack
    }
    
    //MARK: - FUNCAO ENVIAR
    func addTarget() async {
        let _value = self.currencyManager.getDouble()
        
        let target = Target(id: nil, descricao: self.descricao, valor: _value, posicao: self.prioridade, imagem: self.source, coin: self.typeCoin)
        
        //print("\(target)")
        
        do {
            let _ = try await Api.shared.addTarget(target: target)
            
            sendSucesso = true
        } catch {
            print("\(error.localizedDescription)")
            self.error = error.localizedDescription
        }
        
        loading = false
    }
}

/*#Preview {
    AddView()
}*/
