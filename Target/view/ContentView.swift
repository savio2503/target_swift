//
//  ContentView.swift
//  target
//
//  Created by Sávio Dutra on 17/12/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var auth = AuthViewModel.shared
    
    //MARK: - BODY
    var body: some View {
        
        #if os(macOS)
        NavigationSplitView {
            SidebarView()
                .environmentObject(auth)
        } detail: {
            MainView()
        }
        #else
        DrawerWrapper()
            .environmentObject(auth)
        #endif
        
    }
}


