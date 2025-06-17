//
//  SidebarView.swift
//  target
//
//  Created by Sávio Dutra on 07/05/25.
//

import Foundation
import SwiftUI
import ComponentsCommunication

struct SidebarView: View {
    #if !os(macOS)
    @Binding var showSidebar: Bool
    #endif
    @EnvironmentObject var auth: AuthViewModel
    @State private var selectedSorting: String = "Porcentagem"
    @State private var showLogin = false
    @State private var showSignout = false
    @State private var showAdd = false
    @State private var showDeposit = false
    @State private var apertouOpcaoSide: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            
            //Foto e nome
            HStack {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 40, height: 40)
                
                Spacer()
                
                Text(auth.userName)
                    .font(.headline)
                
                Spacer()
            }
            .padding(.top)
            
            Divider()
            
            //Add
            Button(action: {
                apertouOpcaoSide = true
                showAdd.toggle()
            }) {
                Label("Adicionar", systemImage: "plus")
            }
            .disabled(KeysStorage.shared.token == nil)
            
            //Ordernar
            Menu {
                Button("Porcentagem") { selectedSorting = "Porcentagem" }
                Button("Previsao") { selectedSorting = "Previsao" }
                Button("Peso") { selectedSorting = "Peso" }
            } label: {
                Label(selectedSorting, systemImage: "arrow.up.arrow.down")
                    .fixedSize()
            }
            .disabled(KeysStorage.shared.token == nil)
            .frame(maxWidth: 140)
            
            divisor(texto: "Movimentaçao")
            
            // Depositos/Saques
            Button(action: {
                apertouOpcaoSide = true
                showDeposit.toggle()
            }) {
                Label("Depositos/Sacar", systemImage: "banknote")
            }
            .disabled(KeysStorage.shared.token == nil)
            
            divisor(texto: "Visualizar")
            
            //Visualizacao
            
            Menu {
                Button("Bloco") { auth.isBloco = true }
                Button("Lista") { auth.isBloco = false }
            } label: {
                Label(auth.isBloco ? "Bloco" : "Lista", systemImage: auth.isBloco ? "square.grid.3x3.fill" : "line.3.horizontal")
                    .fixedSize()
            }
            .disabled(KeysStorage.shared.token == nil)
            .frame(maxWidth: 100)
            
            Spacer()
            
            // Sign in / Sign out
            Button(action: {
                if KeysStorage.shared.token == nil {
                    showLogin.toggle()
                } else {
                    showSignout.toggle()
                }
            }) {
                Label(KeysStorage.shared.token != nil ? "Sign out" : "Sign in", systemImage: KeysStorage.shared.token != nil ? "rectangle.portrait.and.arrow.right" : "person.fill.badge.plus")
            }
        }
        .padding()
        .frame(maxWidth: 250, alignment: .topLeading)
        #if os(macOS)
        .sheet(isPresented: $showAdd) {
            if showAdd {
                AddView(sheetIsPresented: $showAdd)
            }
        }
        .sheet(isPresented: $showDeposit) {
            if showDeposit {
                MoneyView()
            }
        }
        #else
        .navigationDestination(isPresented: $showDeposit) {
            MoneyView()
                .onDisappear() {
                    #if !os(macOS)
                    showSidebar = false
                    #endif
                }
        }
        .navigationDestination(isPresented: $showAdd) {
            AddView(sheetIsPresented: $showAdd)
        }
        #endif
        .navigationDestination(isPresented: $showLogin) {
            LoginBaseView()
                .onDisappear() {
                    #if !os(macOS)
                    showSidebar = false
                    #endif
                }
        }
        .alert("Tem certeza que deseja sair?", isPresented: $showSignout) {
                    Button("Cancelar", role: .cancel) { }
                    Button("Sair", role: .destructive) {
                        
                        removeAllSaves()
                        
                        KeysStorage.shared.token = nil
                        KeysStorage.shared.recarregar = true
                    
                        auth.isLoggedIn = false
                        #if !os(macOS)
                        showSidebar = false
                        #endif
                    }
                } message: {
                    Text("Essa ação encerrará sua sessão atual.")
                }
        .onAppear {
            #if !os(macOS)
            print("onAppear DrawerWrapper")
            if apertouOpcaoSide {
                showSidebar = false
                apertouOpcaoSide = false
            }
            #endif
        }
        .onChange(of: showAdd) { newValue in
            if !newValue && KeysStorage.shared.recarregar {
                print("retornou showAdd")
                auth.updateTarget = true
            }
        }.onChange(of: showDeposit) { newValue in
            if !newValue && KeysStorage.shared.recarregar {
                print("retornou showAdd")
                auth.updateTarget = true
            }
        }
    }
    
    private func divisor(texto: String) -> some View {
        HStack {
            // Divider da esquerda
            Rectangle()
                .frame(maxWidth: .infinity) // Largura fixa para o divisor vertical
                .frame(height: 1) // Altura máxima possível
                .foregroundColor(.gray)

            Text(texto)
                .fixedSize() // Garante que não quebre nem abrevie
                .padding(.horizontal, 8)

            // Divider da direita
            Rectangle()
                .frame(maxWidth: .infinity) // Largura fixa para o divisor vertical
                .frame(height: 1) // Altura máxima possível
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    
    @Previewable @State var isOn = true
    
    var auth = AuthViewModel.shared
    
    #if os(macOS)
    SidebarView()
        .environmentObject(auth)
    #else
    SidebarView(showSidebar: $isOn)
        .environmentObject(auth)
    #endif
}
