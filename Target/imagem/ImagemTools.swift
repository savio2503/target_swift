//
//  ImagemTools.swift
//  target
//
//  Created by Sávio Dutra on 08/12/24.
//

import SwiftUI

func saveImage(image: String, id: Int) {
    let key = "image_\(id)"
    let date = Date()
    
    UserDefaults.standard.set(image, forKey: key)
    UserDefaults.standard.set(date, forKey: "\(key)_lastUpdated")
}

func loadImage(id: Int) -> String? {
    let key = "image_\(id)"
    
    if let result = UserDefaults.standard.string(forKey: key) {
        return result
    }
    
    return nil
}

func getLastUpdate(id: Int) -> Date? {
    let key = "image_\(id)"
    
    if let date = UserDefaults.standard.object(forKey: "\(key)_lastUpdated") as? Date {
        /*let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return formatter.string(from: date)*/
        return date
    }
    
    return nil
}

func removeAllSaves() {
    let defaults = UserDefaults.standard

    // Obtenha todas as chaves armazenadas
    let allKeys = defaults.dictionaryRepresentation().keys

    // Filtre as chaves que correspondem aos padrões desejados
    let keysToRemove = allKeys.filter { $0.hasPrefix("image") || $0.hasSuffix("lastUpdated") }

    // Remova cada chave filtrada
    for key in keysToRemove {
        print("removendo \(key)")
        defaults.removeObject(forKey: key)
    }

    // Sincronize para garantir a persistência
    defaults.synchronize()

    print("Chaves removidas: \(keysToRemove)")
}
