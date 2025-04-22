//
//  ContentView.swift
//  target
//
//  Created by Sávio Dutra on 17/12/23.
//

import SwiftUI
import ComponentsCommunication

struct ContentView: View {
    
    //MARK: - PROPERTIES
    @State private var showLogin = false
    @State private var showAdd = false
    @State private var showErroAdd = false
    @State var items: [Target] = []
    @State var filteredItems: [Target] = []
    @State var msgError: String = ""
    @State var loading: Bool = true
    @State private var isSearching: Bool = false
    @State private var searchText: String = ""
    @Environment(\.colorScheme) var colorScheme
    private var sizeWith: Double
    @State private var textFieldWidth: CGFloat = 0
    
    init() {
        KeysStorage.shared.recarregar = true
        
        sizeWith = UIScreen.screenWith
        
        print("size: \(sizeWith)")
    }
    
    //MARK: - BODY
    var body: some View {
        NavigationStack {
            
            TabMainView(loading: $loading, items: filteredItems.isEmpty ? $items : $filteredItems)
                .navigationTitle(isSearching ? "" : "Objetivos")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            
                            if KeysStorage.shared.token == nil {
                                self.showErroAdd.toggle()
                                return
                            }
                            
                            showAdd = true
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                        }
                        .alert(isPresented: $showErroAdd) {
                            Alert(
                                title: Text("Warning"),
                                message: Text(
                                    "To be able to add a new objective you must be logged in."),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        if isSearching {
                            TextField("Buscar...", text: $searchText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .tint(colorScheme == .dark ? .white : .black)
                                .frame(minWidth: sizeWith/2 - 65, maxWidth: sizeWith + 125)
                        } else {
                            Button(action: {
                                withAnimation {
                                    isSearching.toggle()
                                }
                            }) {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        if isSearching {
                            Button(action: {
                                withAnimation {
                                    isSearching.toggle()
                                    searchText = ""
                                    filteredItems = []
                                }
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.white)
                            }
                        } else {
                            Button(action: {
                                showLogin = true
                            }) {
                                Image(systemName: "person.circle.fill")
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }  //: TOOLBAR
                .navigationDestination(isPresented: $showLogin) {
                    LoginBaseView()
                        .onDisappear {
                            
                            if KeysStorage.shared.recarregar {
                                loading = true
                                KeysStorage.shared.recarregar = false
                                
                                Task {
                                    items = await TargetController.getTargets()
                                    loading = false
                                    updatesImagemMain()
                                }
                            }
                        }
                }
                .navigationDestination(isPresented: $showAdd) {
                    AddView()
                }  //: NAVIGATIONDESTINATION
            
        }  //: NAVIGATIONSTACK
        .onAppear {
            updateNavigationBarAppearance()
            
            if KeysStorage.shared.recarregar {
                loading = true
                KeysStorage.shared.recarregar = false
                
                Task {
                    items = await TargetController.getTargets()
                    //****
                    //filteredItems.removeAll(keepingCapacity: false)
                    //filteredItems = items
                    loading = false
                    
                    updatesImagemMain()
                }
            }
            
        }
        .onChange(of: colorScheme) { _,__ in
            updateNavigationBarAppearance()
        }
        .onChange(of: searchText) { _,__ in
            filterItems()
        }
        //.tint(.white)
    }
    
    func updatesImagemMain() {
        Task {
            await withTaskGroup(of: (Int, String).self) { group in
                for (index, target) in items.enumerated() {
                    group.addTask {
                        let imagem = await TargetController.getImagens(target: target, tamMax: 100)
                        return (index, imagem)
                    }
                }
                
                for await (index, imagem) in group {
                    DispatchQueue.main.async {
                        items[index].imagem = imagem
                    }
                }
            }
        }
    }
    
    func filterItems() {
        if searchText.isEmpty {
            filteredItems = []
        } else {
            filteredItems = items.filter { target in
                target.descricao.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    func updateNavigationBarAppearance() {
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(Color("NavigationColor"))
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }
}
