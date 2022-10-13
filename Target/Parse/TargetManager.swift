//
//  TargetManager.swift
//  Target
//
//  Created by Sávio Dutra on 12/10/22.
//

import Foundation

class TargetManager {
    
    static func deleteTarget(target: Target) {
        
        var listDebit = DebitManager.debitsFromTarget(target: target)
        
        for debit in listDebit {
            DebitManager.deleteDebit(debit: debit)
        }
        
        target.delete { result in
            print("target deletado com sucesso")
        }
    }
    
    static func createTarget(descricao: String, valorInicial: Double, valorFinal: Double) {
        
        var newTarget = Target()
        
        newTarget.descricao = descricao
        newTarget.valorFinal = valorFinal
        newTarget.usuario = UserManager.manager.user?.objectId!
        
        let savedTarget = try? newTarget.save()
        
        if savedTarget != nil {
            print("Salvo o target com sucesso \(savedTarget)")
            
            if (valorInicial > 0.0) {
                
                DebitManager.createDebit(target: savedTarget!, valor: valorInicial)
            }
            
        } else {
            print("Erro ao tentar criar")
        }
    }
    
    static func readAllTarget() -> [Target] {
        
        var res: [Target] = []
        
        let userId: String = UserManager.manager.user!.objectId!
        
        let query = Target.query()//("usuario" == userId)
        
        let fetchedItems = try? query.find()
        
        if fetchedItems != nil {
            if !fetchedItems!.isEmpty {
                for item in fetchedItems! {
                    
                    if (item.usuario == userId) {
                        
                        res.append(item)
                    }
                }
            }
        }
        
        return res
        
    }
}
