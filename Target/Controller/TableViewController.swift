//
//  TableViewController.swift
//  Target
//
//  Created by Sávio Dutra on 03/10/22.
//

import UIKit
import ParseSwift

class TableViewController: UITableViewController {
    
    var listaTarget: [Target] = []
    
    override func viewDidLoad() {
      super.viewDidLoad()

      tableView.rowHeight = 190.0
        
    }

    override func viewDidAppear(_ animated: Bool) {
        self.recuperarTargets()
    }

    override func didMove(toParent parent: UIViewController?) {
      super.didMove(toParent: parent)

      if parent == nil {
        print("Apertou para desologar")

        do {
          try User.logout()

          UserManager.manager.user = nil
            
            print("Deslogou")
        } catch let error as ParseError {
          showMessage(title: "Error", message: "Failed to log out: \(error.message)")
        } catch {
          showMessage(title: "Error", message: "Failed to log out: \(error.localizedDescription)")
        }
      }
    }
    
    func recuperarTargets() {
        print("chamando recuperarTargets()")
        TargetManager.readAllTarget() { (result) -> () in
            print("chamando setTargetResult(size: \(result.count)")
            self.setTargetResult(result: result)
        }
    }
    
    func setTargetResult(result: [Target]) {
        
        listaTarget = result
        
        self.tableView.reloadData()
        
        print("finish")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaTarget.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "objetivosCell", for: indexPath) as! ObjetivoCelula
        
        let target = listaTarget[indexPath.row]
        
        let descricao = target.descricao!
        let valorInicial = Utils.rounded(valor: DebitManager.someDebitFromTarget(target: target))
        let valorFinal = Utils.rounded(valor: target.valorFinal!)
        let tipo = target.tipoValor == 1 ? TypeValue.Real : TypeValue.Dolar
        
        cell.tituloObjetivo.text = descricao
        cell.valorAtual.text = Utils.doubleToCurrency(value: valorInicial, tipo: tipo)
        cell.valorFinal.text = Utils.doubleToCurrency(value: valorFinal, tipo: tipo)
        
        print("target[\(indexPath.row)]: vd: \(valorFinal), vs: \(cell.valorFinal.text!)")
        
        let porce = Utils.rounded(valor: (valorInicial * 100) / valorFinal)
        
        cell.porcetagemTexto.text = "\(String(porce)) %"
        
        cell.progress.setProgress(Float(porce / 100), animated: true)

        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTarget" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let viewDestino = segue.destination as! EditTargetViewController
                viewDestino.target = self.listaTarget[indexPath.row]
            }
        }
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let indice = indexPath.row
            
            TargetManager.deleteTarget(target: listaTarget[indice])
            
            listaTarget.remove(at: indice)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    

}
