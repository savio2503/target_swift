//
//  ButtonEdit.swift
//  target
//
//  Created by Sávio Dutra on 14/01/24.
//

import SwiftUI

struct ButtonEdit: View {
    
    var target: Target
    @State var isLoading: Bool = false
    
    var body: some View {
        
        if !isLoading {
            HStack {
                
                Spacer()
                
                Button(action: {
                    print("tocou")
                }) {
                    HStack {
                        Text("Salvar")
                            .foregroundStyle(.blue)
                            .padding(.horizontal, 10)
                    }
                    .padding()
                    .background(Color("CardColor"))
                    .cornerRadius(30.0)
                }
                .padding()
                
                Spacer()
                
                Button(action: {
                    Task {
                        isLoading = true
                        print("isLoading = true")
                        do {
                            try await Api.shared.removeTarget(targetId: target.id!)
                        }
                        print("isLoading = false")
                        isLoading = false
                    }
                }) {
                    HStack {
                        Text("Excluir")
                            .foregroundStyle(.red)
                            .padding(.horizontal, 10)
                    }
                    .padding()
                    .background(Color("CardColor"))
                    .cornerRadius(30.0)
                }
                .padding()
                
                Spacer()
            }
        } else {
            Text("Loading...")
        }
    }
}

/*#Preview {
    ButtonEdit(targetId: 1)
}*/
