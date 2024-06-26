//
//  ContentView.swift
//  target
//
//  Created by Sávio Dutra on 17/12/23.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - PROPERTIES
    @State private var showLogin = false
    @State private var showAdd = false
    @State private var showErroAdd = false
    @State var items: [Target] = []
    @State var msgError: String = ""
    @State var loading: Bool = true
    
    init() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(Color("NavigationColor"))
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        
        KeysStorage.shared.recarregar = true
    }
    
    //MARK: - BODY
    var body: some View {
        NavigationStack {
            
            TabMainView(loading: $loading, items: $items)
                .navigationTitle("Objetivos")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            print("plus tapped")
                            
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
                        Button(action: {
                            print("user tapped!")
                            showLogin = true
                        }) {
                            Image(systemName: "person.circle.fill")
                                .foregroundColor(.white)
                        }
                    }
                    
                }  //: TOOLBAR
                .navigationDestination(isPresented: $showLogin) {
                    LoginBaseView()
                        .onDisappear {
                            print("Login()")
                            
                            loading = true
                            
                            if KeysStorage.shared.recarregar {
                                
                                KeysStorage.shared.recarregar = false
                                
                                Task {
                                    print("Content 1 getTarget()")
                                    items = await TargetController.getTargets()
                                    loading = false
                                }
                            }
                        }
                }
                .navigationDestination(isPresented: $showAdd) {
                    AddView()
                }  //: NAVIGATIONDESTINATION
            
        }  //: NAVIGATIONSTACK
        .onAppear {
            
            loading = true
            print("onAppear contentView")
            
            if KeysStorage.shared.recarregar {
                
                KeysStorage.shared.recarregar = false
                
                Task {
                    print("Content 2 getTarget()")
                    items = await TargetController.getTargets()
                    loading = false
                    print("finish task onAppear")
                }
            }
            
            print("finish onAppear contentview")
            
        }
    }
}

/*#Preview {
 ContentView()
 }*/
