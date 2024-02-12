//
//  ImageView.swift
//  target
//
//  Created by Sávio Dutra on 06/01/24.
//

import SwiftUI

struct ImageView: View {
    
    var source: String
    var sizeMaxImage: Double
    
    var body: some View {
        if source.contains("http") {
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
            EmptyView()
        }
    }
}

/*#Preview {
    ImageView()
}*/
