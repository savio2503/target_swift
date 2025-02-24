//
//  ButtonEdit.swift
//  target
//
//  Created by Sávio Dutra on 14/01/24.
//

import SwiftUI
import ComponentsCommunication

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
                
                Spacer()
                
                if (target.comprado == 0 && target.porcentagem! >= 99.9) {
                    
                    Button(action: {
                        Task {
                            isLoading = true
                            print("isLoading = true")
                            do {
                                try await Api.shared.comprar(idTarget: target.id!)
                                KeysStorage.shared.recarregar = true
                                dismiss()
                            }
                            print("isLoading = false")
                            isLoading = false
                        }
                    }) {
                        HStack {
                            Text("Comprar")
                                .foregroundStyle(.green)
                                .padding(.horizontal, 10)
                        }
                        .padding()
                        .background(Color("CardColor"))
                        .cornerRadius(30.0)
                    }
                    
                    Spacer()
                }
                
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
                
                Spacer()
            }
        } else {
            Text("Loading...")
        }
    }
    
    func editTarget() async {
        do {
            var targetAux = Target(from: target)
            
            if targetAux.url != nil && targetAux.url!.isEmpty {
                targetAux.url = nil
            }
            if (target.imagem! == imagemOrigem) {
                targetAux.imagem = nil
            }
            
            _ = try await Api.shared.editTarget(target: targetAux)
            
        } catch {
            print("\(error.localizedDescription)")
        }
        
        isLoading = false
    }
}

/*#Preview {
    ButtonEdit(target: Target(id: 1, descricao: "", valor: 0.0, posicao: 1, porcetagem: 99.9, imagem: " ", coin: 1, removebackground: 0, comprado: 0), imagemOrigem: " ")
}*/
