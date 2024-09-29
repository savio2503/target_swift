//
//  ProgressView.swift
//  target
//
//  Created by Sávio Dutra on 23/01/24.
//

import SwiftUI

struct ProgressView: View {

    @State private var showDetail = false
    @State private var targetClicked: Target?
    @Binding var targets: [Target]
    @Binding var total: Double
    @Binding var showMoney: Bool
    
    private let sizeBlock = 170.0

    var body: some View {
        NavigationStack {
            VStack {
                
                Text("Total value in progress: \(total.toCurrency() ?? "0.00")")
                    .padding(.top, 8)
                
                if (targets.isEmpty) {
                    
                    Spacer()
                    
                    Text("You haven't target created")
                    
                    Spacer()
                    
                } else {
                    
                    ScrollView {
                        LazyVGrid(columns: getGridRows(), spacing: 16) {
                            ForEach(targets, id: \.self) { target in
                                VStack {
                                    if target.porcetagem ?? 0.0 < 99.99 {
                                        ImageWebView(source: target.imagem)
                                        
                                        Text(target.descricao)
                                            .lineLimit(1)
                                            .padding(.horizontal, 6)
                                        
                                        Text(String(format: "%.2f% %", target.porcetagem ?? 0.0))
                                    } else {
                                        ImageWebView(source: target.imagem, imageHeight: 100)
                                        
                                        Text(target.descricao)
                                            .lineLimit(1)
                                            .padding(.horizontal, 6)
                                            .padding(.top, 2)
                                        
                                        Text("Buy")
                                            .padding(.vertical, 1)
                                            .padding(.horizontal, 30)
                                            .background(.green)
                                            .clipShape(Capsule())
                                        
                                        Spacer().frame(height: 10)
                                    }
                                }
                                .background(Color.blue.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                                .frame(minWidth: sizeBlock, maxWidth: sizeBlock, minHeight: sizeBlock, maxHeight: sizeBlock)
                                .onTapGesture {
                                    print("tocou em \(target.descricao)")
                                    targetClicked = target
                                    showDetail.toggle()
                                    
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    }
                }
            }
            .navigationDestination(isPresented: $showDetail) {
                DetailView(target: targetClicked ?? Target(id: 1, descricao: "", valor: 0.0, posicao: 1, imagem: " ", removebackground: 0))
            }
        }
        .sheet(isPresented: $showMoney) {
            MoneyView()
        }.onAppear {
            print("onAppear progress")
        }
        .overlay(
            ZStack {
                Button(action: {
                    self.showMoney.toggle()
                }) {
                    if KeysStorage.shared.token != nil && !self.targets.isEmpty {
                        Image("exchange")
                            .resizable()
                            .scaledToFit()
                            .background(Circle().fill(.clear))
                            .frame(width: 48, height: 48, alignment: .center)
                    }
                }  //: BUTTON
                .accentColor(.blue)

            }  //: ZSTACK
            .padding(.bottom, 15)
            .padding(.trailing, 15), alignment: .bottomTrailing
        )//: OVERLAY 
    }
    
    
}

/*#Preview {
    //let targets = [Target(id: 1, descricao: "teste", valor: 20.5, posicao: 1, imagem: " ")]
    ProgressView()//(targets: targets)
}*/
