//
//  ImageView.swift
//  target
//
//  Created by Sávio Dutra on 06/01/24.
//

import SwiftUI
#if canImport(UIKit)
public typealias PlatformImage = UIImage
#elseif canImport(AppKit)
public typealias PlatformImage = NSImage
#endif

struct ImageView: View {
    @Binding var source: String
    @Binding var removedbackground: Bool
    var sizeMaxImage: Double
    @State private var isShowingConfirmationDialog = false
    @State private var isShowingURLInput = false
    @State private var urlTemp: String = ""
    @State private var isShowPicker = false
    @State private var image = PlatformImage()
    @State private var avatarImage: Image?
    @State private var btnBackground: String = "Remover background"
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            if source.count > 5 && source.prefix(5).contains("http") {
                imageFromURL(source)
            } else if !source.contains(" ") {
                imageFromBase64(source)
            } else {
                Button(action: {
                    isShowingConfirmationDialog = true
                }) {
                    Text("Adicionar uma Imagem")
                        .foregroundStyle(.white)
                        .padding()
                        .background(Color.blue.opacity(0.85))
                        .cornerRadius(5.0)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
        }
        .alert("From Web", isPresented: $isShowingURLInput) {
            TextField("Type or paste the web address", text: $urlTemp)
            Button("OK") {
                source = urlTemp
                removedbackground = false
            }
            Button("Cancel") {}
        }
        .confirmationDialog("Adicionar Imagem", isPresented: $isShowingConfirmationDialog) {
            Button("From Device") {
                isShowPicker = true
            }
            Button("From Web") {
                isShowingURLInput = true
            }
        } message: {
            Text("Escolha a origem da imagem")
        }
        .sheet(isPresented: $isShowPicker) {
            #if os(macOS)
            ImagePicker(selectedImage: self.$image)
            #else
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
            #endif
        }
        .onChange(of: image) { newImage in
            Task {
                if let resizedImage = newImage.resizeToFill() {
                    #if os(macOS)
                    avatarImage = Image(nsImage: resizedImage)
                    
                    if let tiffData = resizedImage.tiffRepresentation,
                       let bitmapRep = NSBitmapImageRep(data: tiffData),
                       let pngData = bitmapRep.representation(using: .png, properties: [:]) {
                        source = pngData.base64EncodedString()
                    }
                    #else
                    avatarImage = Image(uiImage: resizedImage)
                    if let imageData = resizedImage.pngData() {
                        source = imageData.base64EncodedString()
                    }
                    #endif
                }
                removedbackground = false
            }
        }
        .onLongPressGesture {
            isShowingConfirmationDialog.toggle()
        }
        #if os(macOS)
        .contextMenu {
            Button("Editar Imagem") {
                isShowingConfirmationDialog.toggle()
            }
        }
        #endif
    }
    
    private func removerBackground() async -> String? {
        var response: String? = nil
        btnBackground = "Removendo..."
        
        do {
            let imgbackground = try await RemoveBackground.remove(source: source)
            if imgbackground != nil {
                response = imgbackground
            }
        } catch {
            print(error.localizedDescription)
        }
        
        btnBackground = "Remover background"
        return response
    }
    
    #if os(macOS)
    private func imageFromData(data: Data) -> NSImage? {
        return NSImage(data: data)
    }
    #else
    private func imageFromData(data: Data) -> UIImage? {
        return UIImage(data: data)
    }
    #endif
    
    @ViewBuilder
    private func imageFromURL(_ urlString: String) -> some View {
        VStack {
            AsyncImage(url: URL(string: urlString)) { phase in
                switch phase {
                case .empty:
                    Image(systemName: "xmark.circle")
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: sizeMaxImage, maxHeight: sizeMaxImage)
                        .padding(.bottom, 2)
                case .failure:
                    Image(systemName: "xmark.circle")
                @unknown default:
                    Image(systemName: "questionmark.circle")
                }
            }
            if !removedbackground {
                HStack {
                    Spacer()
                    Button(action: {
                        Task {
                            if let res = await removerBackground() {
                                source = res
                                removedbackground = true
                            }
                        }
                    }) {
                        Text(btnBackground)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func imageFromBase64(_ base64: String) -> some View {
        if let data = Data(base64Encoded: base64),
           let uiImage = imageFromData(data: data) {
            VStack {
                #if os(macOS)
                Image(nsImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: sizeMaxImage, maxHeight: sizeMaxImage)
                    .padding(.bottom, 2)
                #else
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: sizeMaxImage, maxHeight: sizeMaxImage)
                    .padding(.bottom, 2)
                #endif
                if !removedbackground {
                    HStack {
                        Spacer()
                        Button(action: {
                            Task {
                                if let res = await removerBackground() {
                                    source = res
                                    removedbackground = true
                                }
                            }
                        }) {
                            Text(btnBackground)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                    }
                }
            }
        }
    }
}
