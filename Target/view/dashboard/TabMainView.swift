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
    @Environment(\.colorScheme) var colorScheme
    
    /// Keep track of tab view customizations in app storage.
    #if !os(macOS) && !os(tvOS)
    @AppStorage("sidebarCustomizations") var tabViewCustomization: TabViewCustomization
    #endif
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @Namespace private var namespace
    @State private var selectedTab: Tabs = .progress
    
    var body: some View {
        if loading {
            Text("Carregando...")
        } else if !loading && KeysStorage.shared.token == nil {
            Text("Por favor, fazer login!")
        } else if KeysStorage.shared.token != nil{
            TabView(selection: $selectedTab) {
                Tab(Tabs.progress.name, systemImage: Tabs.progress.symbol, value: .progress) {
                    ProgressView(targets: $progressTarget, total: $totalProgress, showMoney: $sendMoney)
                }
                .customizationID(Tabs.progress.customizationID)
                // Disable customization behavior on the watchNow tab to ensure that the tab remains visible.
                #if !os(macOS) && !os(tvOS)
                .customizationBehavior(.disabled, for: .sidebar, .tabBar)
                #endif
                
                Tab(Tabs.complete.name, systemImage: Tabs.complete.symbol, value: .complete) {
                    CompleteView(targets: $completeTarget, total: $totalComplete)
                }
                .customizationID(Tabs.complete.customizationID)
                // Disable customization behavior on the watchNow tab to ensure that the tab remains visible.
                #if !os(macOS) && !os(tvOS)
                .customizationBehavior(.disabled, for: .sidebar, .tabBar)
                #endif
                /*ProgressView(targets: $progressTarget, total: $totalProgress, showMoney: $sendMoney)
                    .tabItem {
                        Image(systemName: "figure.run")
                        Text("Em Progresso")
                    }
                    .accentColor(.orange)
                
                CompleteView(targets: $completeTarget, total: $totalComplete)
                    .tabItem {
                        Image(systemName: "target")
                        Text("Completados")
                    }*/
            }
            .tabViewStyle(.sidebarAdaptable)
            #if !os(macOS) && !os(tvOS)
            .tabViewCustomization($tabViewCustomization)
            #endif
            .onAppear {
                let appearance = UITabBarAppearance()
                appearance.backgroundColor = UIColor(Color.blue.opacity(0.2))
                
                UITabBar.appearance().standardAppearance = appearance
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
            .onAppear {
                
                if KeysStorage.shared.token != nil && KeysStorage.shared.recarregar {
                    
                    KeysStorage.shared.recarregar = false
                    
                    Task {
                        items = await TargetController.getTargets()
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
                        items = await TargetController.getTargets()
                        fill()
                    }
                }
            }
            .onChange(of: items) {
                fillSearch()
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
    
    private func fillSearch() {
        progressTarget.removeAll(keepingCapacity: false)
        completeTarget.removeAll(keepingCapacity: false)
        
        items.forEach({ item in
            if (item.comprado ?? 0 == 0) {
                progressTarget.append(item)
            } else {
                completeTarget.append(item)
            }
        })
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
