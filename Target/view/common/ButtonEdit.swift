//
//  ButtonEdit.swift
//  target
//
//  Created by Sávio Dutra on 14/01/24.
//

import SwiftUI

struct ButtonEdit: View {
    
    var target: Target
    var imagemOrigem: String
    @State var isLoading: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        if !isLoading {
            HStack {
                
                Spacer()
                
                Button(action: {
                    //print("tocou salvar")
                    
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
                            KeysStorage.shared.recarregar = true
                            dismiss()
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
            if (target.imagem! != imagemOrigem) {
                _ = try await Api.shared.editTarget(target: target)
            } else {
                var targetAux = Target(from: target)
                targetAux.imagem = nil
                _ = try await Api.shared.editTarget(target: targetAux)
            }
        } catch {
            print("\(error.localizedDescription)")
        }
        
        isLoading = false
    }
}

/*#Preview {
    ButtonEdit(targetId: 1)
}*/
