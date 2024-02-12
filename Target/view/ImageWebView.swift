//
//  ImageWebView.swift
//  target
//
//  Created by Sávio Dutra on 03/02/24.
//

import SwiftUI

struct ImageWebView: View {
    
    var source: String
    let defaultImage: Image = Image(systemName: "cart")
    var imageWidth: Double
    var imageHeight: Double
    
    init(source: String, imageWidth: Double = 160, imageHeight: Double = 125) {
        self.source = source
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
    }
    
    var body: some View {
        if source.contains("http") {
            AsyncImage(url: URL(string: source)) { imagedown in
                switch imagedown {
                case .empty:
                    defaultImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: self.imageWidth, height: self.imageHeight)
                        .cornerRadius(10)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: self.imageWidth, height: self.imageHeight)
                        .cornerRadius(10)
                case .failure(_):
                    defaultImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: self.imageWidth, height: self.imageHeight)
                        .cornerRadius(10)
                @unknown default:
                    defaultImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: self.imageWidth, height: self.imageHeight)
                        .cornerRadius(10)
                }
            }
        } else if !source.contains(" ") {
            
            if let data = Data(base64Encoded: source),
               let uiImage = UIImage(data: data) {
                
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: self.imageWidth, height: self.imageHeight)
                    .cornerRadius(10)
                
            } else {
                defaultImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: self.imageWidth, height: self.imageHeight)
                    .cornerRadius(10)
            }
                
            
        } else {
            defaultImage
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: self.imageWidth, height: self.imageHeight)
                .cornerRadius(10)
        }
    }
}

#Preview {
    ImageWebView(source: "https://e7.pngegg.com/pngimages/1013/132/png-clipart-linux-distribution-tux-free-software-linux-kernel-linux-logo-bird.png")
}
