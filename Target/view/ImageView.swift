//
//  ImageView.swift
//  target
//
//  Created by Sávio Dutra on 06/01/24.
//

import SwiftUI

struct ImageView: View {
    
    @Binding var source: String
    var sizeMaxImage: Double
    @State private var isShowingConfirmationDialog = false
    @State private var isShowingURLInput = false
    @State private var urlTemp: String = ""
    @State private var isShowPicker = false
    @State private var image = UIImage()
    @State private var avatarImage: Image?
    
    var body: some View {
        VStack {
            if source.count > 5 && source.substring(to: 5).contains("http") {
                AsyncImage(url: URL(string: source)) { image in
                    image
                        .image?.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: sizeMaxImage, maxHeight: sizeMaxImage)
                        .padding(.bottom, 2)
                }
            } else if !source.contains(" ") {
                if let data = Data(base64Encoded: source), let uiImage = UIImage(data: data) {
                    
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: sizeMaxImage, maxHeight: sizeMaxImage)
                        .padding(.bottom, 2)
                    
                } else {
                    
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
            Button("OK", action: {source = urlTemp})
            Button("Cancel") {  }
        }
        .confirmationDialog("Adicionar Imagem", isPresented: $isShowingConfirmationDialog) {
            Button("From Device") {
                print("From Device")
                isShowPicker = true
            }
            Button("From Web") {
                print("From Web")
                isShowingURLInput = true
            }
            
        } message: {
            Text("Escolha a origem da imagem")
        }
        .sheet(isPresented: $isShowPicker) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
        }
        .onChange(of: image) {
            Task {
                if let resizedImage = image.resizeToFill() {
                    
                    avatarImage = Image(uiImage: resizedImage)
                    
                    let _uiimage = self.image
                    let _imageData = _uiimage.pngData()
                    let _base64String = _imageData?.base64EncodedString()
                    
                    source = _base64String ?? " "
                    
                }
            }
        }
        .onLongPressGesture() {
            print("onLongPress")
            isShowingConfirmationDialog.toggle()
        }
    }
}

/*#Preview {
    ImageView(source: " ", sizeMaxImage: 300)
}*/
