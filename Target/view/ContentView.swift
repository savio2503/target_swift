//
//  ContentView.swift
//  target
//
//  Created by Sávio Dutra on 17/12/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showLogin = false
    @State var items: [Target] = []
    @State var logging = false
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
              ScrollView {
                  
                    Text("Total investido: \(sumTotalList())")
                      .padding(.top, 16)
                  
                          LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                              ForEach(items, id: \.self) { item in
                                  CardView(target: item)
                              }
                          }
                          .padding()
                      }
          }
          .navigationTitle("Objetivos")
          .navigationBarTitleDisplayMode(.inline)
          .toolbar() {
              ToolbarItem(placement: .topBarLeading) {
                  Button(action: {
                      print("plus tapped")
                  }) {
                      Image(systemName: "plus")
                          .foregroundColor(.white)
                  }
              }
              ToolbarItem(placement: .topBarTrailing) {
                  Button(action: {
                      print("user tapped!")
                      showLogin = true
                  }) {
                      Image(systemName: "person.circle.fill")
                          .foregroundColor(.white)
                  }
              }
          }
          .navigationDestination(isPresented: $showLogin) {
              LoginBaseView()
                  .onDisappear {
                      print("Login()")
                      
                      if KeysStorage.shared.recarregar {
                          
                          KeysStorage.shared.recarregar = false
                          
                          Task {
                              await getTargets()
                          }
                      }
                  }
          }
      }.onAppear {
          
          
          if KeysStorage.shared.recarregar {
              
              KeysStorage.shared.recarregar = false
              
              Task {
                  await getTargets()
              }
          }
      }
  }
    
    private func sumTotalList() -> String {
        
        var total: Double = 0.0
        
        for target in items {
            
            let valorAtual = target.total_deposit ?? 0.0
            
            //print("des: \(target.descricao) -> \(valorAtual)")
            
            total += valorAtual
        }
        
        return String(format: "R$ %.02f", total)
        
    }
    
    private func getTargets() async {
        
        logging = true
        
        do {
            let response = try await Api.shared.getAllTarget(state: true)
            
            //print("Resposta do get target: \(response) ")
            print("total target: \(response.count)")
            
            items.removeAll(keepingCapacity: false)
            
            items = response.map { $0 }
            
        } catch {
            print("erro ao fazer o get target: \(error)")
            msgError = error.localizedDescription
        }
        
        logging = false
    }
}

struct CardView: View {
    let target: Target
    private var sizeMaxImage: Double = 0.0
    
    init(target: Target) {
        
        sizeMaxImage = UIScreen.screenWith < UIScreen.screenHeight ? UIScreen.screenWith : UIScreen.screenHeight
        
        sizeMaxImage = ( sizeMaxImage / 2 ) - 25
        
        //print("size: \(sizeMaxImage)")
        
        self.target = target
    }
    
    var body: some View {
        VStack {
            VStack {
                
                if (target.imagem.contains("http")) {
                    AsyncImage(url: URL(string: target.imagem)) { image in
                        image
                            .image?.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: sizeMaxImage, maxHeight: sizeMaxImage)
                            .padding(.bottom, 2)
                    }
                } else if (!target.imagem.contains(" ")) {
                    
                    if let data = Data(base64Encoded: target.imagem), let uiImage = UIImage(data: data) {
                        
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: sizeMaxImage, maxHeight: sizeMaxImage)
                            .padding(.bottom, 2)
                        
                    } else {
                        
                    }
                } else {
                    Image(systemName: "bag.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                        .padding(.bottom, 2)
                }
                
                
                Text("\(target.posicao) - \(target.descricao)")
                    .padding(.bottom, 2)
                    .frame(maxWidth: .infinity)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                Text("\(String(format: "%.02f", target.porcetagem)) %")
                    .padding(.bottom, 2)
                    .frame(maxWidth: .infinity)
            }
            .padding()
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .cornerRadius(10)
            .padding(.bottom, 2)
            
        }
        .frame(maxWidth: sizeMaxImage, maxHeight: sizeMaxImage)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .padding(.horizontal, 5)
    }
}

/*#Preview {
    ContentView()
}*/
