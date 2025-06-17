//
//  GroupTargetsView.swift
//  target
//
//  Created by Sávio Dutra on 02/06/25.
//

import SwiftUI
import ComponentsCommunication

struct GroupTargetsView: View {
    
    @Binding var listTarget: [Target]
    @State var auth = AuthViewModel.shared
    @State private var gridRows: [GridItem]
    private let sizeBlock = 180.0
    @State private var showDetail = false
    @State private var targetClicked: Target?
    @State private var girou: Bool = false
    @Binding var showMoney: Bool
    
    private var defaultTarget: Target {
        Target(id: 1, descricao: "", valor: 0.0, posicao: 1, porcentagem: 0.0, imagem: " ", removebackground: 0)
    }
    
    init (listTarget: Binding<[Target]>, showMoney: Binding<Bool>) {
        _listTarget = listTarget
        _showMoney = showMoney
        _gridRows = State(initialValue: getGridRows())
    }
    
    var body: some View { //, screenSize = auth.sizeInitWindow
        VStack {
            if auth.isBloco {
                LazyVGrid(columns: gridRows, spacing: 16) {
                    
                    ForEach(listTarget, id: \.self) { target in
                        #if os(macOS)
                        TargetItemView(target: target, size: sizeBlock, isBloco: auth.isBloco) { tappedTarget in
                            DispatchQueue.main.async {
                                print("\(showDetail) progress, tapped: \(tappedTarget.id ?? 0)")
                                self.targetClicked = tappedTarget
                                self.showDetail = true
                            }
                        }
                        #else
                        TargetItemView(target: target, size: sizeBlock, isBloco: auth.isBloco) { tappedTarget in
                            DispatchQueue.main.async {
                                print("\(showDetail) progress, tapped: \(tappedTarget.id ?? 0)")
                                self.targetClicked = tappedTarget
                                self.showDetail = true
                            }
                        }
                        #endif
                    }
                }
            } else {
                ForEach(listTarget, id: \.self) { target in
                    
                    #if os(macOS)
                    TargetItemView(target: target, size: sizeBlock, isBloco: auth.isBloco) { tappedTarget in
                        DispatchQueue.main.async {
                            print("\(showDetail) progress, tapped: \(tappedTarget.id ?? 0)")
                            self.targetClicked = tappedTarget
                            self.showDetail = true
                        }
                    }
                    .padding()
                    #else
                    TargetItemView(target: target, size: sizeBlock, isBloco: auth.isBloco) { tappedTarget in
                        DispatchQueue.main.async {
                            print("\(showDetail) progress, tapped: \(tappedTarget.id ?? 0)")
                            self.targetClicked = tappedTarget
                            self.showDetail = true
                        }
                    }
                    #endif
                }
            }
        }
        .onChange(of: showDetail) { newValue in
            if !newValue && KeysStorage.shared.recarregar {
                print("ParaAtualizar")
                showMoney.toggle()
            }
        }
        .onChange(of: girou) { newValue in
            if newValue {
                gridRows = getGridRows()
                girou = false
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
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            print("Dispositivo girou")
            //gridRows = getGridRows()
            girou.toggle()
        }
        #endif
        
    }
}

#Preview {
    
    @Previewable @State var target: [Target] = [
        Target(id: 1, descricao: "Target 1", valor: 20.0, posicao: 1, porcentagem: 0.0, imagem: " ", removebackground: 0),
        Target(id: 1, descricao: "Target 2", valor: 0.0, posicao: 1, porcentagem: 0.0, imagem: " ", removebackground: 0)
    ]
    @Previewable @State var showMoney: Bool = false
    
    GroupTargetsView(listTarget: $target, showMoney: $showMoney)
}
