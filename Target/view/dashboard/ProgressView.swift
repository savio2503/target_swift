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
    @Binding var porcentagem: Double
    private var defaultTarget: Target {
        Target(id: 1, descricao: "", valor: 0.0, posicao: 1, porcentagem: 0.0, imagem: " ", removebackground: 0)
    }
    private let sizeBlock = 170.0
    
    @State private var gridRows = getGridRows()

    var body: some View {
        NavigationStack {
            VStack {
                
                Text("Total value in progress: \(total.toCurrency() ?? "0.00") = \(porcentagem, specifier: "%.2f")%")
                    .padding(.top, 8)
                
                if (targets.isEmpty) {
                    
                    Spacer()
                    
                    Text("You haven't target created")
                    
                    Spacer()
                    
                } else {
                    
                    ScrollView {
                        LazyVGrid(columns: gridRows, spacing: 16) {
                            
                            ForEach(targets, id: \.self) { target in
                                TargetItemView(target: target, size: sizeBlock) { tappedTarget in
                                    DispatchQueue.main.async {
                                        print("\(showDetail) progress, tapped: \(tappedTarget.id ?? 0)")
                                        self.targetClicked = tappedTarget
                                        self.showDetail = true
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    }
                    .scrollIndicators(.hidden)
                    //.scrollTargetBehavior(.paging)
                }
            }
            #if os(macOS)
            .sheet(isPresented: $showDetail) {
                if (showDetail) {
                    DetailView(target: targetClicked ?? defaultTarget, sheetIsPresented: $showDetail)
                }
            }
            #else
            .navigationDestination(isPresented: $showDetail) {
                //print("\(showDetail)")
                if (showDetail) {
                    DetailView(target: targetClicked ?? defaultTarget, sheetIsPresented: $showDetail)
                }
            }
            #endif
        }
        .onChange(of: showDetail) { newValue in
            if !newValue && KeysStorage.shared.recarregar {
                print("ParaAtualizar")
                showMoney.toggle()
            }
        }
        .onAppear {
            print("onAppear ProgressView")
        }
        #if !os(macOS)
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            print("Dispositivo girou")
            gridRows = getGridRows()
        }
        #endif
    }
    
    
}

/*#Preview {
    //let targets = [Target(id: 1, descricao: "teste", valor: 20.5, posicao: 1, imagem: " ")]
    ProgressView()//(targets: targets)
}*/
