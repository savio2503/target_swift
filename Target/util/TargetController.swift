//
//  Target.swift
//  target
//
//  Created by Sávio Dutra on 10/03/24.
//

import Foundation
import ComponentsCommunication

class TargetController {
    
    static var loading = true
    
    private static var targets: [Target] = []
    
    static func updateImage(idTarget: Int, imagem: String) {
        if let index = targets.firstIndex(where: { $0.id == idTarget}) {
            targets[index].imagem = imagem
        }
    }
    
    static func getTargets() async -> [Target] {
        
        loading = true
        
        if KeysStorage.shared.token != nil {
            
            do {
                let response = try await Api.shared.getAllTarget()
                
                targets.removeAll(keepingCapacity: false)
                
                targets = response.map { $0 }
                
                let formatter = DateFormatter()
                formatter.timeZone = TimeZone(secondsFromGMT: 0)
                formatter.dateFormat = "dd/MM/yyyy HH:mm"
                
                var bufferImage: String? = ""
                
                for target in targets {
                    
                    //pegar o id e o update_at
                    let detailImage = await Api.shared.getDetailImage(idTarget: target.id!)
                    let dateImage = detailImage.updatedAt != nil ? formatter.date(from: detailImage.updatedAt!) : Date()
                    
                    //compare com a data salva, se tiver
                    let dateLocal = getLastUpdate(id: target.id!)
                    
                    if (dateLocal != nil && dateLocal! >= dateImage!) {
                        bufferImage = loadImage(id: target.id!)
                    } else {
                        
                        let downImage = try await Api.shared.getImage(idTarget: target.id!)
                        
                        saveImage(image: downImage.imagem ?? " ", id: target.id!)
                        
                        bufferImage = downImage.imagem
                    }
                    
                    if bufferImage != nil && bufferImage!.prefix(5).contains("http") {
                        await saveImageUrl(idTarget: target.id!, url: bufferImage!)
                    } else {
                        updateImage(idTarget: target.id!, imagem: bufferImage!)
                    }
                }
                
            } catch {
                KeysStorage.shared.token = nil
            }
        } else {
            
            targets.removeAll(keepingCapacity: false)
        }
        
        loading = false
        
        return targets
    }
}
