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
    @State private var isShowingConfirmationDialog = false
    @State private var isShowingURLInput = false
    @State private var urlTemp: String = ""
    @State private var imageURL: String?
    @State private var image = UIImage()
    @State private var avatarImage: Image?
    @State private var isShowPicker = false
    @State private var textMenu = "R$"
    @State private var typeCoin = 1
    @State private var error = ""
    
    @ObservedObject private var currencyManager = CurrencyManager(
        amount: 0,
        locale: .init(identifier: "pt_BR")
    )
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                
                if imageURL != nil {
                    ImageWebView(source: self.imageURL!, imageWidth: 250, imageHeight: 250)
                        .padding(.top, 16)
                }
                
                if avatarImage != nil {
                    avatarImage?
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                }
                
                if avatarImage == nil && imageURL == nil {
                    Button(action: {
                        isShowingConfirmationDialog = true
                    }) {
                        Text("Adicionar uma imagem")
                            .foregroundStyle(.white)
                            .padding()
                            .background(Color.blue.opacity(0.85))
                            .cornerRadius(5.0)
                    }//:BUTTON
                    .padding(.top, 16)
                    .alert("From Web", isPresented: $isShowingURLInput) {
                        TextField("Type or paste the web address", text: $urlTemp)
                        Button("OK", action: submit)
                        Button("Cancel") {  }
                    }
                    .confirmationDialog("Adicionar Imagem", isPresented: $isShowingConfirmationDialog) {
                        Button("From Device") {
                            print("From Device")
                            isShowPicker = true
                        }
                        Button("From Web") {
                            print("From Web")
                            isShowingURLInput = true
                        }
                        
                    } message: {
                        Text("Escolha a origem da imagem")
                    }
                }
                
                
                
                TextField("Descricao", text: $descricao)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.horizontal, 16)
                
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
                }
                .padding(.horizontal, 16)
                
                
                Text("Selecione o peso do objetivo")
                    .padding()
                
                PriorityView(selectNumber: self.$prioridade)
                    .padding()
                
                Spacer()
                
                if !error.isEmpty {
                    Text(error)
                        .foregroundStyle(.red)
                }
                
                Button(action: {
                    
                    if descricao.isEmpty || valor == 0.0 {
                        error = "O campo de descrição ou o campo de valor estâo vazios"
                    }
                    
                }) {
                    Text("Adicionar")
                        .foregroundStyle(.white)
                        .padding()
                        .background(Color.blue.opacity(0.85))
                        .cornerRadius(5.0)
                }
                .padding(.bottom, 8)
                
                
            }//: VSTACK
            .navigationTitle("Add a new Target")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isShowPicker) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
            }
            .onChange(of: image) {
                Task {
                    avatarImage = Image(uiImage: image)
                }
            }
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
    
    func submit() {
        imageURL = urlTemp
        print("url eh: \(imageURL!)")
    }
}

#Preview {
    AddView()
}
