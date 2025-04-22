//
//  TargetItemView.swift
//  target
//
//  Created by Sávio Dutra on 21/04/25.
//

import SwiftUI
import ComponentsCommunication

struct TargetItemView: View {
    let target: Target
    let size: Double
    let onTap: (Target) -> Void
    
    var body: some View {
        VStack {
            if target.porcentagem ?? 0.0 < 99.99 {
                ImageWebView(source: target.imagem ?? " ", imageId: target.id!)

                Text(target.descricao)
                    .lineLimit(1)
                    .padding(.horizontal, 6)

                Text(formattedPorcentagem(target.porcentagem))
                    .foregroundColor(.gray)

            } else {
                ImageWebView(source: target.imagem ?? " ", imageId: target.id!, imageHeight: 100)

                Text(target.descricao)
                    .lineLimit(1)
                    .padding(.horizontal, 6)
                    .padding(.top, 2)

                Text("Buy")
                    .padding(.vertical, 1)
                    .padding(.horizontal, 30)
                    .background(.green)
                    .clipShape(Capsule())
                    .foregroundColor(.white)

                Spacer().frame(height: 10)
            }
        }
        .background(Color.blue.opacity(0.1))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
        )
        .frame(minWidth: size, maxWidth: size, minHeight: size, maxHeight: size)
        .onTapGesture {
            onTap(target)
        }        
    }
}
