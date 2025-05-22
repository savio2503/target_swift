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
    
    static func getImagens(target: Target, tamMax: Int? = nil) async -> String {
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        
        var bufferImage: String? = ""
        
        //print("loop para o target: \(target.descricao)")
        //pegar o id e o update_at
        let detailImage = await Api.shared.getDetailImage(idTarget: target.id!)
        let dateImage = detailImage.updatedAt != nil ? formatter.date(from: detailImage.updatedAt!) : Date()
        
        //compare com a data salva, se tiver
        let dateLocal = getLastUpdate(id: target.id!)
        
        //print("id: \(target.id!), data local: \(dateLocal ?? formatter.date(from: "01/01/2000 00:00:00")), data remote: \(dateImage!)")
        
        if (dateLocal != nil && dateLocal! >= dateImage!) {
            //print("usando o local")
            bufferImage = loadImage(id: target.id!)
        } else {
            //print("usando o server")
            var downImage: ImageTarget = ImageTarget(id: nil, idTarget: nil, updatedAt: nil, imagem: nil)
            
            do {
                downImage = try await Api.shared.getImage(idTarget: target.id!, tamMax: tamMax)
            }catch {
                print("erro ao baixar imagem: \(error)")
            }
            
            saveImage(image: downImage.imagem ?? " ", id: target.id!, dateServer: dateImage)
            
            bufferImage = downImage.imagem
        }
        
        if bufferImage != nil && bufferImage!.prefix(5).contains("http") {
            bufferImage = await getImageUrl(idTarget: target.id!, url: bufferImage!)
        } else {
            bufferImage = bufferImage ?? " "
        }
        
        //print("buffer: \(bufferImage!.substring(from: 25, length: 10))")
        
        return bufferImage!
    }
    
    static func getTargets() async -> [Target] {
        
        loading = true
        
        if KeysStorage.shared.token != nil {
            
            do {
                let response = try await Api.shared.getAllTarget()
                
                targets.removeAll(keepingCapacity: false)
                
                targets = response.map { $0 }
                
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
