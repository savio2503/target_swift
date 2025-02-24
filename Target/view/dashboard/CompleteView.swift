//
//  CompleteView.swift
//  target
//
//  Created by Sávio Dutra on 23/01/24.
//

import SwiftUI
import ComponentsCommunication

struct CompleteView: View {
    
    @State private var showMoney = false
    @State private var showDetail = false
    @State private var targetClicked: Target?
    @Binding var targets: [Target]
    @Binding var total: Double

    var body: some View {
        NavigationStack {
            VStack {
                
                Text("Total value in complete: \(total.toCurrency() ?? "0.00")")
                    .padding(.top, 8)
                
                if targets.isEmpty {
                    
                    Spacer()
                    
                    Text("You haven't target completed")
                    
                    Spacer()
                    
                } else {
                    
                    ScrollView {
                        LazyVGrid(columns: getGridRows(), spacing: 16) {
                            ForEach(targets, id: \.self) { target in
                                VStack {
                                    ImageWebView(source: target.imagem ?? " ")
                                    //     .padding()
                                    
                                    Text(target.descricao)
                                        .lineLimit(1)
                                        .padding(.horizontal, 6)
                                    
                                    Text(formattedPorcentagem(target.porcentagem))
                                        .foregroundColor(.gray)
                                }
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                                .onTapGesture {
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
            // Conteúdo da sheet
        }
        .onAppear {
        }
    }
}

/*#Preview {
    CompleteView()
}*/
