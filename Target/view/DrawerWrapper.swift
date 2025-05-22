//
//  DrawerWrapper.swift
//  target
//
//  Created by Sávio Dutra on 07/05/25.
//
#if !os(macOS)
import Foundation
import SwiftUI

struct DrawerWrapper: View {
    @EnvironmentObject var auth: AuthViewModel
    @State private var showSidebar = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
            NavigationStack {
                ZStack {
                    MainView()
                        .disabled(showSidebar)
                        .blur(radius: showSidebar ? 3 : 0)
                    
                    if showSidebar {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation { showSidebar = false }
                            }
                    }

                    HStack {
                        if showSidebar {
                            SidebarView(showSidebar: $showSidebar)
                                .frame(width: 250)
                                .background(Color(.systemBackground))
                                .transition(.move(edge: .leading))
                        }
                        Spacer()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            withAnimation {
                                showSidebar.toggle()
                            }
                        }) {
                            Image(systemName: "line.3.horizontal")
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                    }
                }
            }
        }
}

#endif
