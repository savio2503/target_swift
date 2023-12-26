//
//  ContentView.swift
//  target
//
//  Created by Sávio Dutra on 17/12/23.
//

import SwiftUI
import FlowStack

struct ContentView: View {
    
    @State private var showLogin = false
    
    let items = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6"]

    
    init() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(red: 0.12, green: 0.55, blue: 0.95, alpha: 1.00)
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }
    
  var body: some View {
      NavigationStack {
          VStack {
              ScrollView {
                          LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                              ForEach(items, id: \.self) { item in
                                  CardView(item: item)
                              }
                          }
                          .padding()
                      }
          }
          .navigationTitle("Objetivos")
          .navigationBarTitleDisplayMode(.inline)
          .toolbar() {
              ToolbarItem(placement: .topBarLeading) {
                  Button(action: {
                      print("plus tapped")
                  }) {
                      Image(systemName: "plus")
                          .foregroundColor(.white)
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
          }
          .navigationDestination(isPresented: $showLogin) {
              LoginBaseView()
          }
      }
  }
}

struct CardView: View {
    let item: String
    
    var body: some View {
        VStack {
            Text(item)
                .padding()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
                .padding(.bottom, 10)
            
        }
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .padding(.horizontal, 5)
    }
}

#Preview {
    ContentView()
}
