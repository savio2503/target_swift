//
//  TargetManager.swift
//  Target
//
//  Created by Sávio Dutra on 12/10/22.
//

import Foundation

class TargetManager {
    
    static func updateTarget(target: Target) {
        
        target.save { result in
            print("Atualização salva com sucesso! \(target.objectId)")
        }
    }
    
    static func deleteTarget(target: Target) {
        
        var listDebit = DebitManager.debitsFromTarget(target: target)
        
        for debit in listDebit {
            DebitManager.deleteDebit(debit: debit)
        }
        
        target.delete { result in
            print("target deletado com sucesso")
        }
    }
    
    static func createTarget(descricao: String, valorInicial: Double, valorFinal: Double, completion: @escaping (Bool) -> ()) {
        
        var newTarget = Target()
        
        newTarget.descricao = descricao
        newTarget.valorFinal = valorFinal
        newTarget.usuario = UserManager.manager.user?.objectId!
        
        newTarget.save { result in
            switch result {
            case .success(let targetResult) :
                print("salvo o target com Sucesso \(targetResult)")
                
                if (valorInicial > 0.0) {
                    DebitManager.createDebit(target: targetResult, valor: valorInicial)
                }
                
                completion(true)
            case .failure(let error) :
                print("Error ao criar o target: \(error)")
            }
        }
    }
    
    static func readAllTarget(completion: @escaping ([Target]) -> ()) {
        
        var res: [Target] = []
        
        let userId: String = UserManager.manager.user!.objectId!
        
        let query = Target.query()
        
        query.find { result in
            switch result {
                case .success (let targets):
                
                for item in targets {
                    if (item.usuario == userId) {
                        res.append(item)
                    }
                }
                
                completion(res)
                
            case .failure(let error):
                print ("Error ao buscar os targets: \(error)")
            }
        }
        
    }
}
