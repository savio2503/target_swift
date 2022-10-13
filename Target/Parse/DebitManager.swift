//
//  DebitManager.swift
//  Target
//
//  Created by Sávio Dutra on 12/10/22.
//

import Foundation
import ParseSwift

class DebitManager {
    
    static func deleteDebit(debit: Debit) {
        
        debit.delete { resut in
            print("deletado com sucesso")
        }
    }
    
    static func createDebit(target: Target, valor: Double) {
        
        var newDebit = Debit()
        
        newDebit.target = target
        newDebit.valor = valor
        
        let savedDebit = try? newDebit.save()
        
        if savedDebit != nil {
            print("Debito salvo com sucesso! \(savedDebit)")
        } else {
            print("Erro ao salvar o debito!")
        }
    }
    
    static func debitsFromTarget(target: Target) -> [Debit]{
        
        var res: [Debit] = []
        
        let query = Debit.query()
        
        let fetchItems = try? query.find()
        
        if fetchItems != nil {
            if !fetchItems!.isEmpty {
                for item in fetchItems! {
                    if (item.target?.objectId == target.objectId) {
                        res.append(item)
                    }
                }
            }
        }
        
        return res
        
    }
    
    static func someDebitFromTarget(target: Target) -> Double{
        
        var lista: [Debit] = debitsFromTarget(target: target)
        var res: Double = 0.0
        
        for item in lista {
            
            res += item.valor!
        }
        
        return res
        
    }
}
