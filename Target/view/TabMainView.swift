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
    
    var body: some View {
        if loading {
            Text("Carregando")
        } else if !loading && KeysStorage.shared.token == nil {
            Text("Por favor, fazer login!")
        } else {
            TabView {
                ProgressView(targets: $items)
                    .tabItem {
                        Image(systemName: "figure.run")
                        Text("Em Progresso")
                    }
                
                CompleteView()
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
        }
    }
}

/*#Preview {
    TabMainView()
}*/
