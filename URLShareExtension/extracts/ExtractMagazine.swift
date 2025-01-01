//
//  ExtractMagazine.swift
//  URLShareExtension
//
//  Created by Sávio Dutra on 30/12/24.
//

import Foundation
import SwiftSoup

class ExtractMagazine {
    
    func extractMagazineData(from html: String, sharedContent: SharedContent) {
        do {
            // Parse o HTML
            let document = try SwiftSoup.parse(html)
            
            var productTitle: String?
            var productImageURL: String?
            var productPrice: String?
            
            
            
            // Extrair título (descrição)
            if let titleElement = try document.select("h1.sc-dcJsrY.jjGTqv").first() {
                productTitle = try titleElement.text()
            }
            
            // Extrair preço
            if let priceElement = try document.select("p.sc-dcJsrY.eLxcFM.sc-fmzyuX.dIyuod").first() {
                productPrice = try priceElement.text()
                productPrice = productPrice?.replacingOccurrences(of: "[ˆ0-9]", with: "", options: .regularExpression)
            }
            
            //extrair imagem
            if let imageElement = try document.select("img.sc-hzhJZQ.knorgy").first() {
                productImageURL = try imageElement.attr("src")
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
