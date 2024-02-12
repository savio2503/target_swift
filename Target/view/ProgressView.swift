//
//  ProgressView.swift
//  target
//
//  Created by Sávio Dutra on 23/01/24.
//

import SwiftUI

struct ProgressView: View {

    @State private var showMoney = false
    @Binding var targets: [Target]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: getGridRows(), spacing: 16) {
                ForEach(targets, id: \.self) { target in
                    VStack {
                        ImageWebView(source: target.imagem)
                            //.padding()
                        
                        Text(target.descricao)
                            .lineLimit(1)
                            .padding(.horizontal, 6)
                        
                        Text(String(format: "%.2f% %", target.porcetagem!))
                    }
                    .background(Color.blue.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                }
            }
            .padding(16)
        }
        .sheet(isPresented: $showMoney) {

        }
        /*.overlay(
            ZStack {
                Button(action: {
                    self.showMoney.toggle()
                }) {
                    if KeysStorage.shared.token != nil {
                        Image(systemName: "dollarsign.arrow.circlepath")
                            .resizable()
                            .scaledToFit()
                            .background(Circle().fill(.white))
                            .frame(width: 48, height: 48, alignment: .center)
                    }
                }  //: BUTTON
                .accentColor(.blue)

            }  //: ZSTACK
            .padding(.bottom, 15)
            .padding(.trailing, 15), alignment: .bottomTrailing
        )//: OVERLAY */
    }
    
    private func getGridRows() -> [GridItem] {
        let adaptiveGridItem = GridItem(.adaptive(minimum: 160))
        return Array(repeating: adaptiveGridItem, count: getNumberOfColumns())
    }
    
    private func getNumberOfColumns() -> Int {
        #if os(macOS)
        let windowWidth = NSApplication.shared.windows.first?.frame.width ?? 300
        #else
        let windowWidth = UIScreen.main.bounds.width
        #endif
        let columns = Int(windowWidth / 170)
        //print(columns)
        return max(columns, 1)
    }
}

/*#Preview {
    //let targets = [Target(id: 1, descricao: "teste", valor: 20.5, posicao: 1, imagem: " ")]
    ProgressView()//(targets: targets)
}*/
