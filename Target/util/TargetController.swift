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
    
    static func getTargets() async -> [Target] {
        
        loading = true
        
        if KeysStorage.shared.token != nil {
            
            do {
                let response = try await Api.shared.getAllTarget()
                
                //print("Resposta do get target: \(response) ")
                print("total target: \(response.count)")
                
                targets.removeAll(keepingCapacity: false)
                
                targets = response.map { $0 }
                
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
