//
//  Logged.swift
//  target
//
//  Created by Sávio Dutra on 25/12/23.
//

import SwiftUI

struct LoggedView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Spacer()
        Text("Tela de Logged")
        Spacer()
        Button(action: {
            
            KeysStorage.shared.token = nil
            KeysStorage.shared.recarregar = true
            
            dismiss()
            
        }) {
            //baseButton(text: "deslocar", color: Color.blue)
            HStack {
                Spacer()
                Text("Deslogar")
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding()
            .background(Color.blue)
            .cornerRadius(5.0)
        }
        .padding()
        Spacer()
    }
}

