//
//  ProgressView.swift
//  target
//
//  Created by Sávio Dutra on 23/01/24.
//

import SwiftUI
import ComponentsCommunication

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
                                TargetItemView(target: target, size: sizeBlock) { tappedTarget in
                                    targetClicked = tappedTarget
                                    showDetail.toggle()
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    }
                    .scrollIndicators(.hidden)
                    .scrollTargetBehavior(.paging)
                }
            }
            .navigationDestination(isPresented: $showDetail) {
                DetailView(target: targetClicked ?? Target(id: 1, descricao: "", valor: 0.0, posicao: 1, imagem: " ", removebackground: 0))
            }
        }
        .sheet(isPresented: $showMoney) {
            MoneyView()
        }.onAppear {}
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
                .tint(.blue)

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
