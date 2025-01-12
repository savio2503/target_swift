//
//  ShareViewController.swift
//  URLShareExtension
//
//  Created by Sávio Dutra on 24/12/24.
//

import UIKit
import Social
import SwiftUI
import SwiftSoup
import ComponentsCommunication

class ShareViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        /// Interactive Dismiss Disabled
        isModalInPresentation = true

        // Use um objeto Observável para monitorar o estado
        let sharedContent = SharedContent()

        // Processa os itens compartilhados
        if let inputItems = extensionContext?.inputItems as? [NSExtensionItem] {
            for item in inputItems {
                if let attachments = item.attachments {
                    for attachment in attachments {
                        if attachment.hasItemConformingToTypeIdentifier("public.url") {
                            attachment.loadItem(forTypeIdentifier: "public.url", options: nil) { (data, error) in
                                if let url = data as? URL {
                                    DispatchQueue.main.async {
                                        
                                        processURL(url.absoluteString) { finalURL in
                                            
                                            sharedContent.url = finalURL
                                            
                                            if finalURL.contains("amazon") {
                                                let amazon = ExtractAmazon()
                                                fetchProductData(sharedContent: sharedContent, urlString: finalURL, completion: amazon.extractAmazonData(from:sharedContent:))
                                            } else if finalURL.contains("aliexpress") {
                                                
                                                let ali = ExtractAliexpress()
                                                fetchProductData(sharedContent: sharedContent, urlString: finalURL, completion: ali.extractAliexpressData(from:sharedContent:))
                                            } else if finalURL.contains("kabum") {
                                                
                                                let kabum = ExtractKabum()
                                                fetchProductData(sharedContent: sharedContent, urlString: finalURL, completion: kabum.extractKabumData(from:sharedContent:))
                                            } else if finalURL.contains("mercadolivre") {
                                                
                                                let ml = ExtractML()
                                                fetchProductData(sharedContent: sharedContent, urlString: finalURL, completion: ml.extractMLData(from:sharedContent:))
                                            } else if finalURL.contains("magazineluiza") {
                                                
                                                let magazine = ExtractMagazine()
                                                fetchProductData(sharedContent: sharedContent, urlString: finalURL, completion: magazine.extractMagazineData(from:sharedContent:))
                                            } else {
                                                print("url nao suportada")
                                            }
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        // Renderiza a interface SwiftUI
        let hostingView = UIHostingController(rootView: ShareView(extensionContext: extensionContext, sharedContent: sharedContent))
        hostingView.view.frame = view.frame
        view.addSubview(hostingView.view)
    }
}

// Objeto Observável para estado compartilhado
class SharedContent: ObservableObject {
    @Published var finished: Bool = false
    @Published var descricao: String = ""
    @Published var valor: Int = 0
    @Published var image: String = ""
    @Published var url: String = ""
}


public struct ShareView: View {
    var extensionContext: NSExtensionContext?  // Contexto da extensão
    @ObservedObject var sharedContent: SharedContent  // Observa o conteúdo compartilhado
    var sizeMaxImage: Double = 200  // Tamanho máximo da imagem
    @State var descricao: String = ""  // Descrição
    @State private var textMenu = "R$"  // Texto do menu
    @State var prioridade: Int = 1  // Prioridade do objetivo
    @State var loading: Bool = false
    @State private var error = ""
    @State private var sendSucesso: Bool = false

    public var body: some View {
        VStack(spacing: 15) {
            Text("Adicionar Objetivo")
                .font(.title3.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    Button("Cancel", action: dismiss).tint(.red)  // Botão de cancelamento
                }

            if sharedContent.finished {
                // Exibição da imagem, se a requisição foi finalizada
                ImageWeb(imageurl: sharedContent.image, sizeMaxImage: sizeMaxImage)

                // Campo de texto para a descrição
                TextField("Descricao", text: $sharedContent.descricao)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                
                // Componente de entrada para o valor
                InputCoin(value: $sharedContent.valor)
                
                Text("Selecione o peso do objetivo")
                    .padding(.top, 15)
                
                // Componente de prioridade
                PriorityView(selectNumber: $prioridade)
                    .padding(.horizontal)
                
                if !error.isEmpty {
                    Text(error)
                        .foregroundStyle(.red)
                        .padding(.top, 16)
                }
                
                Button(action: {
                    if sharedContent.descricao.isEmpty || sharedContent.valor == 0 {
                        error = "O campo de descrição ou o campo de valor estâo vazios"
                    } else {
                        print("share, chamou adicionar")
                        Task {
                            sendSucesso = false
                            await addTarget()
                            if sendSucesso {
                                print("share, finalizou adicionar 1")
                                KeysStorage.shared.recarregar = true
                                dismiss()
                            }
                            print("share, finalizou adicionar 2")
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
                
            } else {
                // Caso ainda não tenha carregado, exibe a mensagem "Carregando..."
                Spacer(minLength: 0)
                Text("Carregando...")
            }

            // Espaço extra no final
            Spacer(minLength: 0)
        }
        .padding(15)
        .onTapGesture {
            self.hideKeyboard()
        }
    }

    // Função para cancelar e fechar a extensão
    func dismiss() {
        extensionContext?.completeRequest(returningItems: [])
    }
    
    func addTarget() async {
        do {
            let _value: Double = Double(sharedContent.valor) / 100.0
            let descricao: String = sharedContent.descricao
            let posicao: Int = self.prioridade
            let imagem: String? = sharedContent.image.isEmpty ? nil : sharedContent.image
            let url: String? = sharedContent.url.isEmpty ? nil : sharedContent.url

            // Inicialize o Target explicitamente
            let target = Target(descricao: descricao, valor: _value, posicao: posicao, imagem: imagem, coin: 1, removebackground: 0, comprado: 0, url: url)
            //let targetWithoutId = Target(descricao: "Exemplo sem ID", valor: 100.0, posicao: 2, removebackground: 1)
            //var target = Target()
            
            print("share, chamou a API")
            // Adicione o target via API
            let _ = try await Api.shared.addTarget(target: target)
            
            sendSucesso = true
            
        } catch {
            print("Erro: \(error.localizedDescription)")
            self.error = error.localizedDescription
        }
    }
}

