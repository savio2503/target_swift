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
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        if !isLoading {
            HStack {
                
                Spacer()
                
                Button(action: {
                    print("tocou salvar")
                    
                    isLoading = true
                    Task {
                        await editTarget()
                        dismiss()
                    }
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
    
    func editTarget() async {
        do {
            let response = try await Api.shared.editTarget(target: target)
        } catch {
            print("\(error.localizedDescription)")
        }
        
        isLoading = false
    }
}

/*#Preview {
    ButtonEdit(targetId: 1)
}*/
