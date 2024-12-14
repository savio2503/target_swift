//
//  Target.swift
//  target
//
//  Created by Sávio Dutra on 10/03/24.
//

import Foundation

class TargetController {
    
    static var loading = true
    
    private static var targets: [Target] = []
    
    static func updateImage(idTarget: Int, imagem: String) {
        if let index = targets.firstIndex(where: { $0.id == idTarget}) {
            targets[index].imagem = imagem
            print("Imagem atualizada para o id \(idTarget)")
        } else {
            print("Target com o id \(idTarget) não encontrado.")
        }
    }
    
    static func getTargets() async -> [Target] {
        
        loading = true
        
        if KeysStorage.shared.token != nil {
            
            do {
                let response = try await Api.shared.getAllTarget()
                
                //print("Resposta do get target: \(response) ")
                print("total target: \(response.count)")
                
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
                    
                    print("local: \(dateLocal), banco: \(dateImage)")
                    
                    if (dateLocal != nil && dateLocal! >= dateImage!) {
                        bufferImage = loadImage(id: target.id!)
                        print("usando a imagem local para o id \(target.id!)")
                    } else {
                        
                        let downImage = try await Api.shared.getImage(idTarget: target.id!)
                        
                        saveImage(image: downImage.imagem ?? " ", id: target.id!)
                        
                        bufferImage = downImage.imagem
                        print("usando a imagem banco para o id \(target.id!)")
                    }                    
                    
                    //print("\(target.descricao): \(target.porcetagem)")
                    if bufferImage != nil && bufferImage!.contains("http") {
                        await saveImageUrl(idTarget: target.id!, url: bufferImage!)
                    } else {
                        updateImage(idTarget: target.id!, imagem: bufferImage!)
                    }
                }
                
            } catch {
                print("erro ao fazer o get target: \(error)")
                //msgError = error.localizedDescription
                KeysStorage.shared.token = nil
            }
        } else {
            
            print("deslocado")
            
            targets.removeAll(keepingCapacity: false)
        }
        
        loading = false
        
        return targets
    }
}
