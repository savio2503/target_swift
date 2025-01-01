//
//  TabMainView.swift
//  target
//
//  Created by Sávio Dutra on 01/02/24.
//

import SwiftUI
import ComponentsCommunication

struct TabMainView: View {
    
    @Binding var loading: Bool
    @Binding var items: [Target]
    @State var sendMoney = false
    @State var progressTarget: [Target] = []
    @State var completeTarget: [Target] = []
    @State var totalProgress = 0.0
    @State var totalComplete = 0.0
    
    var body: some View {
        if loading {
            Text("Carregando...")
        } else if !loading && KeysStorage.shared.token == nil {
            Text("Por favor, fazer login!")
        } else if KeysStorage.shared.token != nil{
            TabView {
                ProgressView(targets: $progressTarget, total: $totalProgress, showMoney: $sendMoney)
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
                
                if KeysStorage.shared.token != nil && KeysStorage.shared.recarregar {
                    
                    KeysStorage.shared.recarregar = false
                    
                    Task {
                        //print("TabMainView getTarget()")
                        items = await TargetController.getTargets()
                        //print("finish task onAppear")
                        fill()
                    }
                } else {
                    fill()
                }
            }
            .onChange(of: sendMoney) {
                if (KeysStorage.shared.recarregar) {
                    KeysStorage.shared.recarregar = false
                    
                    Task {
                        //print("start task change getTarget()")
                        items = await TargetController.getTargets()
                        //print("finish task onChange")
                        fill()
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                print("onResume TabMain")
                
                KeysStorage.shared.recarregar = false
                
                Task {
                    items = await TargetController.getTargets()
                    print("finish onResume TabMain")
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
            if (item.comprado ?? 0 == 0) {
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
