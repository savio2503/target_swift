//
//  ImageView.swift
//  target
//
//  Created by Sávio Dutra on 06/01/24.
//

import SwiftUI

struct ImageView: View {
    @Binding var source: String
    @Binding var removedbackground: Bool
    var sizeMaxImage: Double
    @State private var isShowingConfirmationDialog = false
    @State private var isShowingURLInput = false
    @State private var urlTemp: String = ""
    @State private var isShowPicker = false
    @State private var image = UIImage()
    @State private var avatarImage: Image?
    @State private var btnBackground: String = "Remover background"
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            if source.count > 5 && source.prefix(5).contains("http") {
                VStack {
                    AsyncImage(url: URL(string: source)) { phase in
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
                                    let res = await removerBackground()
                                    if res != nil {
                                        source = res!
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
            } else if !source.contains(" ") {
                if let data = Data(base64Encoded: source), let uiImage = UIImage(data: data) {
                    VStack {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: sizeMaxImage, maxHeight: sizeMaxImage)
                            .padding(.bottom, 2)
                        if !removedbackground {
                            HStack {
                                Spacer()
                                Button(action: {
                                    Task {
                                        let res = await removerBackground()
                                        if res != nil {
                                            source = res!
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
            }
        }
        .alert("From Web", isPresented: $isShowingURLInput) {
            TextField("Type or paste the web address", text: $urlTemp)
            Button("OK", action: {
                source = urlTemp
                removedbackground = false
            })
            Button("Cancel") { }
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
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
        }
        .onChange(of: image) { _, newImage in
            Task {
                if let resizedImage = newImage.resizeToFill() {
                    avatarImage = Image(uiImage: resizedImage)
                    if let imageData = resizedImage.pngData() {
                        source = imageData.base64EncodedString()
                    }
                }
                removedbackground = false
            }
        }
        .onLongPressGesture {
            isShowingConfirmationDialog.toggle()
        }
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
}
