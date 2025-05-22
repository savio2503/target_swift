//
//  RemoveBackgroundMacos.swift
//  target
//
//  Created by Sávio Dutra on 07/05/25.
//

#if os(macOS)
import Foundation
import AppKit

class RemoveBackground {
    static func convertImageToBase64(urlString: String) -> String? {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return nil
        }
        
        guard let data = try? Data(contentsOf: url), let image = NSImage(data: data) else {
            print("Failed to load image from URL:", urlString)
            return nil
        }
        
        let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 900, height: 900))
        
        if let tiffData = resizedImage.tiffRepresentation,
           let bitmap = NSBitmapImageRep(data: tiffData),
           let base64String = bitmap.representation(using: .png, properties: [:])?.base64EncodedString() {
            return base64String
        } else {
            print("Failed to convert image to base64")
            return nil
        }
    }

    static private func resizeImage(image: NSImage, targetSize: CGSize) -> NSImage {
        let originalSize = image.size
        
        let widthRatio = targetSize.width / originalSize.width
        let heightRatio = targetSize.height / originalSize.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        let newSize = NSSize(width: originalSize.width * scaleFactor,
                             height: originalSize.height * scaleFactor)
        
        let newImage = NSImage(size: newSize)
        newImage.lockFocus()
        image.draw(in: NSRect(origin: .zero, size: newSize),
                   from: NSRect(origin: .zero, size: originalSize),
                   operation: .copy,
                   fraction: 1.0)
        newImage.unlockFocus()
        
        return newImage
    }
    
    static private func callRemoveBackgroundService(imageData: Data) async -> NSImage? {
        let url = URL(string: "http://192.168.3.20:8080/upload")!
        //let url = URL(string: "http://192.168.3.44:8080/upload")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("image/webp", forHTTPHeaderField: "Content-Type")
        request.httpBody = imageData
        
        var result: NSImage?
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            if let receivedImage = NSImage(data: data) {
                result = receivedImage
            } else {
                print("Failed to convert received data to image")
            }
        } catch {
            print("Error sending image data to web service:", error)
        }
            
        return result
    }
    
    static private func cutImage(image: NSImage) -> NSImage? {
        guard let tiffData = image.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData) else {
            return nil
        }
        
        let width = bitmap.pixelsWide
        let height = bitmap.pixelsHigh
        
        var minX = width
        var maxX = 0
        var minY = height
        var maxY = 0
        
        for x in 0..<width {
            for y in 0..<height {
                let color = bitmap.colorAt(x: x, y: y)
                if let alpha = color?.alphaComponent,
                   alpha > 0 {
                    minX = min(minX, x)
                    maxX = max(maxX, x)
                    minY = min(minY, y)
                    maxY = max(maxY, y)
                }
            }
        }
        
        guard minX <= maxX && minY <= maxY else {
            return nil
        }
        
        let croppedWidth = maxX - minX + 1
        let croppedHeight = maxY - minY + 1
        let croppedSize = NSSize(width: croppedWidth, height: croppedHeight)
        
        let croppedImage = NSImage(size: croppedSize)
        croppedImage.lockFocus()
        
        let drawRect = NSRect(x: 0, y: 0, width: croppedWidth, height: croppedHeight)
        let sourceRect = NSRect(x: minX, y: height - maxY - 1, width: croppedWidth, height: croppedHeight)
        
        image.draw(in: drawRect,
                   from: sourceRect,
                   operation: .copy,
                   fraction: 1.0,
                   respectFlipped: false,
                   hints: nil)
        
        croppedImage.unlockFocus()
        
        return croppedImage
        
    }

    static func remove(source: String) async throws -> String? {
        
        var aux: String?
        
        if source.count > 5 && source.substring(to: 5).contains("http") {
            aux = convertImageToBase64(urlString: source)
        } else if !source.contains(" ") {
            aux = source
        } else {
            return nil
        }
        
        guard let base64String = aux,
              let imageData = Data(base64Encoded: base64String),
              let image = NSImage(data: imageData) else {
            print("Falha ao converter Base64 para imagem")
            return nil
        }
        
        guard let pngData = image.pngData() else {
            print("Erro ao converter NSImage em PNG")
            throw RuntimeError("Erro ao converter imagem para PNG")
        }
        
        guard let imageWithoutBackground = await callRemoveBackgroundService(imageData: pngData) else {
            print("Erro no envio do webservice")
            throw RuntimeError("Erro no envio do webservice")
        }
        
        guard let imageCropped = cutImage(image: imageWithoutBackground) else {
            print("Erro ao cortar a imagem")
            throw RuntimeError("Erro ao cortar a imagem")
        }
        
        guard let croppedData = imageCropped.pngData() else {
            print("Erro ao converter imagem cortada para PNG")
            throw RuntimeError("Erro ao converter imagem cortada para PNG")
        }
        
        return croppedData.base64EncodedString()
    }
}

struct RuntimeError: LocalizedError {
    let description: String

    init(_ description: String) {
        self.description = description
    }

    var errorDescription: String? {
        description
    }
}
#endif
