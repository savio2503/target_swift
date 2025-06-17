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
    let isBloco: Bool
    
    #if os(macOS)
    @State var screenSize: CGSize = CGSize(width: 800, height: 800)
    
    private var sizeImageWidth: CGFloat {
        let sizeFromScreen = screenSize.width / 4
        return sizeFromScreen > 100 ? 100 : sizeFromScreen
    }
    private var sizeContentWidth: CGFloat {
        return screenSize.width - sizeImageWidth - 32
    }
    private var sizeWidthList: CGFloat {
        return screenSize.width - 232
    }
    
    #else
    private var sizeImageWidth: CGFloat {
        let sizeFromScreen =  UIScreen.main.bounds.width / 4
        return sizeFromScreen > 100 ? 100 : sizeFromScreen
    }
    private var sizeContentWidth: CGFloat {
        return UIScreen.main.bounds.width - sizeImageWidth - 32
    }
    private var sizeWidthList: CGFloat {
        return UIScreen.main.bounds.width - 32
    }
    
    private var multi: Double {
        return size * 0.65
    }
    #endif
    
    let onTap: (Target) -> Void
    
    var body: some View {
        VStack {
            if isBloco {
                if target.porcentagem ?? 0.0 < 99.99 {
                    ImageWebView(source: target.imagem ?? " ", imageId: target.id!)
                        .frame(width: size, height: sizeImageWidth)
                    
                    Text(target.descricao)
                        .lineLimit(1)
                        .padding(.horizontal, 6)
                    
                    Text(formattedPorcentagem(target.porcentagem))
                        .foregroundColor(.gray)
                    
                } else {
                    ImageWebView(source: target.imagem ?? " ", imageId: target.id!) //, imageHeight: 100)
                        .frame(width: size, height: sizeImageWidth)
                    
                    Text(target.descricao)
                        .lineLimit(1)
                        .padding(.horizontal, 6)
                        .padding(.top, 2)
                    
                    if ((target.comprado ?? 0) == 1) {
                        Text(formattedPorcentagem(target.porcentagem))
                            .foregroundColor(.gray)
                    } else {
                        Text("Buy")
                            .padding(.vertical, 1)
                            .padding(.horizontal, 30)
                            .background(.green)
                            .clipShape(Capsule())
                            .foregroundColor(.white)
                    }
                    
                    Spacer().frame(height: 10)
                }
            }
            else {
                HStack {
                    ImageWebView(source: target.imagem ?? " ", imageId: target.id!)
                        .frame(width: sizeImageWidth, height: sizeImageWidth)
                    
                    Spacer()
                    
                    VStack {
                        Spacer()
                        
                        Text(target.descricao)
                            .font(.headline)
                            .lineLimit(2)
                            .padding(.horizontal, 6)
                            .padding(.top, 2)
                        
                        Spacer()
                        
                        HStack {
                            Text("\(target.total ?? 0.0, specifier: "%.2f") / \(target.valor, specifier: "%.2f")")
                                .font(.headline)
                            
                            
                            Text(formattedPorcentagem(target.porcentagem))
                                .font(.headline)
                        }
                        
                        Spacer()
                        
                        if target.porcentagem ?? 0.0 >= 99.99
                            && ((target.comprado ?? 0) == 0){
                            Text("Buy")
                                .font(.title2)
                                .padding(.vertical, 1)
                                .padding(.horizontal, 30)
                                .background(.green)
                                .clipShape(Capsule())
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
        .background(Color.blue.opacity(0.1))
        //.background(WindowAccessor(size: $screenSize))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
        )
        /*.frame(minWidth: isBloco ? size : sizeWidthList,
               maxWidth: isBloco ? size : sizeWidthList,
               minHeight: isBloco ? multi : 100,
               maxHeight: isBloco ? multi : 100)*/
        .frame(width: isBloco ? size : sizeWidthList,
               height: isBloco ? multi : 100)
        .onTapGesture {
            onTap(target)
        }
        .padding()
    }
}

#if os(macOS)
struct WindowAccessor: NSViewRepresentable {
    @Binding var size: CGSize
    
    func makeNSView(context: Context) -> NSView {
        let nsView = NSView()
        DispatchQueue.main.async {
            if let window = nsView.window {
                size = window.frame.size
                
                NotificationCenter.default.addObserver(
                    forName: NSWindow.didResizeNotification,
                    object: window,
                    queue: .main
                ) { _ in
                    size = window.frame.size
                }
            }
        }
        return nsView
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        
    }
}
#endif

#Preview {
    
    @Previewable @State var target = Target(id: 1, descricao: "Target 1", valor: 20.0, posicao: 1, porcentagem: 0.0, imagem: " ", removebackground: 0)
    
    TargetItemView(target: target, size: 300, isBloco: false) { tappedTarget in
        DispatchQueue.main.async {
        }
    }
}
