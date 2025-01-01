//
//  ExtractAliexpress.swift
//  Target
//
//  Created by Sávio Dutra on 29/12/24.
//
import Foundation
import SwiftSoup

class ExtractAliexpress {
    func extractAliexpressData(from html: String, sharedContent: SharedContent) {
        do {
            // Parse o HTML
            let document = try SwiftSoup.parse(html)
            
            // 1 - Extrair o título
            let metaTitle = try document.select("meta[property=og:title]").attr("content")
            let title = metaTitle.components(separatedBy: " - ").first ?? " "
            
            // 2 - Extrair a URL da imagem
            let imageUrl = try document.select("meta[property=og:image]").attr("content")
            
            // 3 e 4 - Extrair o preço
            // Selecionando o primeiro elemento de preço
            /*var priceWhole = try document.select(".a-price-whole").first()?.text()
            var priceFraction = try document.select(".a-price-fraction").first()?.text()
            
            priceWhole = priceWhole ?? "0"
            priceFraction = priceFraction ?? "00"
            
            // Remove a vírgula de priceWhole
            let priceWholeClean = priceWhole!.replacingOccurrences(of: ",", with: "")
            
            // Combine os valores no formato "priceWhole.priceFraction"
            let priceString = "\(priceWholeClean).\(priceFraction!)"*/
            
            // Atualize os valores no thread principal
            DispatchQueue.main.async {
                sharedContent.descricao = title
                sharedContent.image = imageUrl
                sharedContent.valor = 0
                sharedContent.finished = true
            }
            
        } catch {
            print("Erro ao processar o HTML: \(error)")
        }
    }
    
}
