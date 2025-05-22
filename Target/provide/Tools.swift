//
//  Tools.swift
//  target
//
//  Created by Sávio Dutra on 18/05/24.
//

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif
import Foundation
import SwiftUI
import ComponentsCommunication

func saveImageUrl(idTarget: Int, url: String) async {
    
    let imageBase64 = RemoveBackground.convertImageToBase64(urlString: url)
    
    if imageBase64 != nil {
        
        do {
            try await Api.shared.changeImage(idTarget: idTarget, image: imageBase64!)
            
            TargetController.updateImage(idTarget: idTarget, imagem: imageBase64!)
            
            saveImage(image: imageBase64!, id: idTarget)
        } catch {
            print("Erro ao enviar update de imagem: \(error)")
        }
    }
}

func getImageUrl(idTarget: Int, url: String) async -> String {
    let imageBase64 = RemoveBackground.convertImageToBase64(urlString: url)
    
    if imageBase64 != nil {
        
        do {
            try await Api.shared.changeImage(idTarget: idTarget, image: imageBase64!)
            
            return imageBase64!
        } catch {
            print("Erro ao enviar update de imagem: \(error)")
        }
    }
    
    return " "
}

func diferencaMeses(dataInicial: Date, dataFinal: Date) -> Int {
    
    let calendar = Calendar.current
    
    let components = calendar.dateComponents([.year, .month], from: dataInicial, to: dataFinal)
    
    return (components.year! * 12) + components.month! + 1
}

func estimative(deposits: [Deposit], objetivo: Double) -> String {
    
    var result = ""
    
    //Ordenar os depositos pela data
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM"
    let sortedDeposits = deposits.sorted { dateFormatter.date(from: $0.mes)! < dateFormatter.date(from: $1.mes)! }
    
    //Calcular o valor total dos Depositos
    let valorTotal = sortedDeposits.reduce(0) { $0 + $1.valor }
    
    guard let dataInicial = dateFormatter.date(from: sortedDeposits.first!.mes),
          let dataFinal = dateFormatter.date(from: sortedDeposits.last!.mes) else {
        return "Erro ao converter datas"
    }
    
    let quantidadeMeses = diferencaMeses(dataInicial: dataInicial, dataFinal: dataFinal)
    
    //calcular a quantidae de meses necessarios para atingir o objetivo
    //let quantidadeMesesObjetivo = Int((objetivo * Double(quantidadeMeses)) / valorTotal) + 1
    let quantidadeMesesObjetivo = Int((objetivo-valorTotal) / (valorTotal / Double(quantidadeMeses))) + 1
    
    //calcular a data em que o objetivo sera atingido
    //let dataObjetivo = incrementarMeses(data: Date(), meses: quantidadeMesesObjetivo)
    let calendar = Calendar.current
    let yearsToAdd = quantidadeMesesObjetivo / 12
    let remainingMonthsToAdd = quantidadeMesesObjetivo % 12
    
    var dateComponent = DateComponents()
    dateComponent.year = yearsToAdd
    dateComponent.month = remainingMonthsToAdd
    
    let dataObjetivo = calendar.date(byAdding: dateComponent, to: Date())!
    
    //Formatar a data de resultado
    let resultDateFormatter = DateFormatter()
    resultDateFormatter.dateFormat = "MM/yyyy"
    let dataObjetivoStr = resultDateFormatter.string(from: dataObjetivo)
    
    result = "You will achieve the objective by: \(dataObjetivoStr)"
    
    return result
}
