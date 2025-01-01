//
//  ExtractML.swift
//  URLShareExtension
//
//  Created by Sávio Dutra on 29/12/24.
//

import Foundation
import SwiftSoup

class ExtractML {
    
    func extractMLData(from html: String, sharedContent: SharedContent) {
        do {
            // Parse o HTML
            let document = try SwiftSoup.parse(html)
            
            var productTitle: String?
            var productImageURL: String?
            var productPrice: String?
            var productPriceDecimal: String?
            
            
            
            // Extrair título (descrição)
            if let titleElement = try document.select("h1.ui-pdp-title").first() {
                productTitle = try titleElement.text()
            }
            
            // Extrair preço
            
            let divElement = try document.select("div.ui-pdp-price__second-line").first()
            
            let fractionSpan = try divElement?.select("span.andes-money-amount__fraction").first()
            let centsSpan = try divElement?.select("span.andes-money-amount__cents").first()
            
            if fractionSpan != nil {
                productPrice = try fractionSpan?.text()
            }
            if centsSpan != nil {
                productPriceDecimal = try centsSpan?.text()
            } else {
                productPriceDecimal = "00"
            }
            
            productPrice = productPrice! + productPriceDecimal!
            
            //extrair imagem
            if let imageElement = try document.select("img.ui-pdp-image.ui-pdp-gallery__figure__image").first() {
                productImageURL = try imageElement.attr("data-zoom")
            }
            
            print("productPrice: \(productPrice ?? "NULL"), productPriceDecimal: \(productPriceDecimal ?? "NULL")")
            
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
