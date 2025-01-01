//
//  ExtractKabum.swift
//  Target
//
//  Created by Sávio Dutra on 29/12/24.
//

import Foundation
import SwiftSoup

class ExtractKabum {
    
    func extractKabumData(from html: String, sharedContent: SharedContent) {
        do {
            // Parse o HTML
            let document = try SwiftSoup.parse(html)
            
            var productTitle: String?
            var productImageURL: String?
            var productPrice: String?
            
            // Extrair título
            if let titleElement = try document.select("meta[property=og:title]").first() {
                productTitle = try titleElement.attr("content")
            }
            
            // Extrair imagem
            if let imageElement = try document.select("meta[property=og:image]").first() {
                productImageURL = try imageElement.attr("content")
            }
            
            // Extrair preço do script application/ld+json
            if let scriptElement = try document.select("script[type=application/ld+json]").first() {
                let jsonData = scriptElement.data().data(using: .utf8)!
                if let jsonObject = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
                   let offers = jsonObject["offers"] as? [String: Any],
                   let price = offers["price"] as? String {
                    productPrice = price
                }
            }
            
            if (productPrice != nil) {
                
                let components = productPrice!.split(separator: ".")
                let hasDecimal = components.count > 1 && !components[1].isEmpty
                
                productPrice = productPrice!.replacingOccurrences(of: ",", with: "")
                productPrice = productPrice!.replacingOccurrences(of: ".", with: "")
                
                if !hasDecimal {
                    productPrice = productPrice! + "00"
                }
            }
            
            // Atualize os valores no thread principal
            DispatchQueue.main.async {
                sharedContent.descricao = productTitle ?? ""
                sharedContent.image = productImageURL ?? " "
                sharedContent.valor = Int(productPrice ?? "0")!
                sharedContent.finished = true
            }
            
        } catch {
            print("Erro ao processar o HTML: \(error)")
        }
    }
    
}
