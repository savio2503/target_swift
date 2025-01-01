//
//  ImageWeb.swift
//  URLShareExtension
//
//  Created by Sávio Dutra on 25/12/24.
//

import SwiftUI

struct ImageWeb: View {
    var imageurl: String
    var sizeMaxImage: Double
    var body: some View {
        VStack {
            if imageurl.count > 5 && imageurl.prefix(5).contains("http") {
                VStack {
                    AsyncImage(url: URL(string: imageurl)) { phase in
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
                }
            } else {
                Image(systemName: "xmark.circle")
            }
        }
    }
}
