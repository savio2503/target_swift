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
    @State var porcetagemProgress: Double = 0.0
    @Environment(\.colorScheme) var colorScheme
    
    /// Keep track of tab view customizations in app storage.
    #if !os(macOS) && !os(tvOS)
    @AppStorage("sidebarCustomizations") var tabViewCustomization: TabViewCustomization
    #endif
    
    @Namespace private var namespace
    @State private var selectedTab: Tabs = .progress
    
    @StateObject var auth = AuthViewModel.shared
    
    var body: some View {
        if loading {
            Text("Carregando...")
        } else if !loading && KeysStorage.shared.token == nil {
            Text("Por favor, fazer login!")
        } else if KeysStorage.shared.token != nil{
            TabView(selection: $selectedTab) {
                Tab(Tabs.progress.name, systemImage: Tabs.progress.symbol, value: .progress) {
                    ProgressView(targets: $progressTarget, total: $totalProgress, showMoney: $sendMoney, porcentagem: $porcetagemProgress)
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
                #if !os(macOS) && !os(tvOS)
                // Disable customization behavior on the watchNow tab to ensure that the tab remains visible.
                .customizationBehavior(.disabled, for: .sidebar, .tabBar)
                #endif
            }
            .tabViewStyle(.tabBarOnly)
            #if !os(macOS) && !os(tvOS)
            .tabViewCustomization($tabViewCustomization)
            #endif
            .onAppear {
                print("onApper TabMain")
                if KeysStorage.shared.token != nil && KeysStorage.shared.recarregar {
                    
                    KeysStorage.shared.recarregar = false
                    
                    Task {
                        print(1)
                        items = await TargetController.getTargets()
                        fill()
                        updatesImagemMain()
                    }
                } /*else {
                    print(2)
                    fill()
                    updatesImagemMain()
                }*/
            }
            .onChange(of: auth.updateTarget) { newValue in
                if newValue && KeysStorage.shared.recarregar {
                    KeysStorage.shared.recarregar = false
                    auth.updateTarget = false
                    print("atualizar apos add tabmain")
                    Task {
                        print(3)
                        items = await TargetController.getTargets()
                        fill()
                        updatesImagemMain()
                    }
                }
            }
            .onChange(of: sendMoney) {
                if (KeysStorage.shared.recarregar) {
                    KeysStorage.shared.recarregar = false
                    
                    Task {
                        print(4)
                        items = await TargetController.getTargets()
                        fill()
                        updatesImagemMain()
                    }
                }
            }
            .onChange(of: items) {
                fillSearch()
            }
            #if !os(macOS)
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            
                KeysStorage.shared.recarregar = false
                
                Task {
                    print(5)
                    items = await TargetController.getTargets()
                    fill()
                    updatesImagemMain()
                }
            }
            #endif
        }
    }
    
    private func updatesImagemMain() {
        if KeysStorage.shared.token != nil {
            Task(priority: .userInitiated) {
                await withTaskGroup(of: (Int, String).self) { group in
                    for (index, target) in items.enumerated() {
                        group.addTask {
                            let imagem = await TargetController.getImagens(target: target, tamMax: 100)
                            return (index, imagem)
                        }
                    }
                    
                    for await (index, imagem) in group {
                        DispatchQueue.main.async {
                            if (index < items.count) {
                                items[index].imagem = imagem
                            } else {
                                print("Index inválido ao tentar atualizar imagem: \(index)")
                            }
                        }
                    }
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
        var totalAberto: Double = 0.0
        
        items.forEach({ item in
            if (item.comprado ?? 0 == 0) {
                progressTarget.append(item)
                totalProgress += item.total ?? 0.0
                totalAberto += item.valor
            } else {
                completeTarget.append(item)
                totalComplete += item.valor
            }
        })
        
        porcetagemProgress = (totalProgress / totalAberto) * 100
    }
}

/*#Preview {
 TabMainView()
 }*/
