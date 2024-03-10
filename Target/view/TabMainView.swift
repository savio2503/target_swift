//
//  TabMainView.swift
//  target
//
//  Created by Sávio Dutra on 01/02/24.
//

import SwiftUI

struct TabMainView: View {
    
    @Binding var loading: Bool
    @Binding var items: [Target]
    @State var progressTarget: [Target] = []
    @State var completeTarget: [Target] = []
    @State var totalProgress = 0.0
    @State var totalComplete = 0.0
    
    var body: some View {
        if loading {
            Text("Carregando...")
        } else if !loading && KeysStorage.shared.token == nil {
            Text("Por favor, fazer login!")
        } else {
            TabView {
                ProgressView(targets: $progressTarget, total: $totalProgress)
                    .tabItem {
                        Image(systemName: "figure.run")
                        Text("Em Progresso")
                    }
                
                CompleteView(targets: $completeTarget, total: $totalComplete)
                    .tabItem {
                        Image(systemName: "target")
                        Text("Completados")
                    }
            }
            .onAppear {
                let appearance = UITabBarAppearance()
                appearance.backgroundColor = UIColor(Color.blue.opacity(0.2))
                
                UITabBar.appearance().standardAppearance = appearance
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
            .onAppear {
                
                print("onAppear TabMain")
                
                if KeysStorage.shared.recarregar {
                    
                    KeysStorage.shared.recarregar = false
                    
                    Task {
                        items = await TargetController.getTargets()
                        print("finish task onAppear")
                        fill()
                    }
                } else {
                    fill()
                }
            }
        }
    }
    
    private func fill() {
        progressTarget.removeAll(keepingCapacity: false)
        completeTarget.removeAll(keepingCapacity: false)
        totalComplete = 0.0
        totalProgress = 0.0
        
        items.forEach({ item in
            if (item.ativo! == 1) {
                progressTarget.append(item)
                totalProgress += item.total ?? 0.0
            } else {
                completeTarget.append(item)
                totalComplete += item.valor
            }
        })
    }
}

/*#Preview {
 TabMainView()
 }*/
