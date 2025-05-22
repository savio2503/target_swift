//
//  MainView.swift
//  target
//
//  Created by Sávio Dutra on 07/05/25.
//

import SwiftUI
import ComponentsCommunication

struct MainView: View {
    
    //MARK: - PROPERTIES
    @State private var showLogin = false
    @State private var showAdd = false
    @State private var showErroAdd = false
    @State var items: [Target] = []
    @State var filteredItems: [Target] = []
    @State var msgError: String = ""
    @State var loading: Bool = true
    @State private var isSearching: Bool = false
    @State private var searchText: String = ""
    @Environment(\.colorScheme) var colorScheme
    private var sizeWith: Double {
        #if !os(macOS)
        UIScreen.screenWith
        #else
        Double(NSScreen.main?.frame.width ?? .zero)
        #endif
    }
    @State private var textFieldWidth: CGFloat = 0
    var tintColor: Color  {
        colorScheme == .dark ? .white : .black
    }
    @StateObject var auth = AuthViewModel.shared
    
    init() {
        KeysStorage.shared.recarregar = true
    }
    
    var body: some View {
        NavigationStack {
            
            TabMainView(loading: $loading, items: filteredItems.isEmpty ? $items : $filteredItems)
                .navigationTitle(isSearching ? "" : "Objetivos")
            #if !os(macOS)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        if isSearching {
                            TextField("Buscar...", text: $searchText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .foregroundColor(tintColor)
                                .tint(tintColor)
                                .frame(minWidth: sizeWith/2 - 65, maxWidth: sizeWith + 125)
                        } else {
                            Button(action: {
                                withAnimation {
                                    isSearching.toggle()
                                }
                            }) {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(tintColor)
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
                                    .foregroundColor(tintColor)
                            }
                        }
                    }
                }  //: TOOLBAR
            #endif
        }  //: NAVIGATIONSTACK
        .onAppear {
            updateNavigationBarAppearance()
            
            if KeysStorage.shared.recarregar {
                loading = true
                KeysStorage.shared.recarregar = false
                
                Task {
                    items = await TargetController.getTargets()
                    loading = false
                }
            }
            
            if KeysStorage.shared.token == nil {
                print("set Auth off")
                auth.isLoggedIn = false
                auth.setTextInit()
            } else if !auth.isLoggedIn {
                print("set Auth on")
                auth.isLoggedIn = true
                auth.userName = "Um Nome Qualquer"
            }
            
        }
        .onChange(of: auth.isLoggedIn) { _,__ in
            if !auth.isLoggedIn {
                print("entrou em onchange Main logout")
                auth.setTextInit()
                items = []
            }
        }
        .onChange(of: tintColor) { _,__ in
            updateNavigationBarAppearance()
        }
        .onChange(of: searchText) { _,__ in
            filterItems()
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
        
        #if !os(macOS)
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(Color("NavigationColor"))
        
        // Cor do título
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(Color("NavigationTitleColor"))]
        
        // Cor dos botões da NavigationBar (como "Objetivos" no botão de voltar)
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(Color("NavigationTitleColor"))]
        //navBarAppearance.buttonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(Color("NavigationTitleColor"))]
        navBarAppearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(Color("NavigationTitleColor"))]
        
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        #endif
    }
}
