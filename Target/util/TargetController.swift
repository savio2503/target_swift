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
                
                for target in targets {
                    
                    //print("\(target.descricao): \(target.porcetagem)")
                    if target.imagem.contains("http") {
                        saveImageUrl(idTarget: target.id!, url: target.imagem)
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
