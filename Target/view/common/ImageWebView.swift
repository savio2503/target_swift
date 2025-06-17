//
//  ImageWebView.swift
//  target
//
//  Created by Sávio Dutra on 03/02/24.
//

import SwiftUI
import Kingfisher
import ComponentsCommunication

struct ImageWebView: View {
    
    var source: String
    var imageId: Int
    var defaultImage: Image = Image(systemName: "cart")
    
    @State private var loadedImage: PlatformImage?
    
    init(source: String, imageId: Int) {
        self.source = source
        self.imageId = imageId
    }
    
    var body: some View {
        content
            .cornerRadius(10)
            .onAppear {
                loadImage()
            }
            .clipped()
    }
    
    @ViewBuilder
    private var content: some View {
        if source.trimmingCharacters(in: .whitespaces).isEmpty {
            defaultImage
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else if source.prefix(5).contains("http") {
            KFImage(URL(string: source))
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else if let image = loadedImage {
            #if !os(macOS)
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            #else
            Image(nsImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            #endif
        } else {
            defaultImage
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
    
    private func loadImage() {
        guard !source.prefix(5).contains("http"),
              !source.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            guard let data = Data(base64Encoded: source),
                  let image = PlatformImage(data: data) else {
                print("Falha ao decodificar base64 para UIImage")
                return
            }

            ImageCacheManager.shared.setImage(image, for: imageId)

            DispatchQueue.main.async {
                self.loadedImage = image
            }
        }
    }
}

/*#Preview {
    ImageWebView(source: "https://e7.pngegg.com/pngimages/1013/132/png-clipart-linux-distribution-tux-free-software-linux-kernel-linux-logo-bird.png")
}*/
