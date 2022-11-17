//
//  EditTargetViewController.swift
//  Target
//
//  Created by Sávio Dutra on 03/10/22.
//

import CoreData
import UIKit

class EditTargetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet weak var tableViewDebit: UITableView!
  @IBOutlet weak var descricaoTarget: UITextField!
  @IBOutlet weak var valorFinalTarget: UITextField!

  private var tituloInicial: String!
  private var valorFinalInicial: String!
    
    var target: Target!
    var listDebit: [Debit] = []
    
    @IBAction func SalvarAtualizacao(_ sender: Any) {
        
        let descricao = descricaoTarget.text
        let valor = Utils.getDoubleValue(value: valorFinalTarget.text)
        
        target.descricao = descricao
        target.valorFinal = valor
        
        TargetManager.updateTarget(target: target)
    }
    

  @IBAction func depositar(_ sender: Any) {
      
      var valor = UITextField()
      
      let alert = UIAlertController(title: "Adicionar um depósito", message: "", preferredStyle: .alert)
      
      let createAction = UIAlertAction(title: "Depositar", style: .default) { (action) in
          
          if valor.text != nil {
              
              let valorDouble = self.getDoubleValue(value: valor.text!)
              
              if valorDouble > 0.0 {
                  
                  DebitManager.createDebit(target: self.target, valor: valorDouble, tipo: TypeValue.Real)
                  self.listDebit = DebitManager.debitsFromTarget(target: self.target)
                  self.tableViewDebit.reloadData()
                  
              }
          }
      }
      
      let cancelAction = UIAlertAction(title: "Cancelar", style: .destructive) { (action) in
          self.dismiss(animated: true, completion: nil)
      }
      
      alert.addTextField { (alertTextField) in
          alertTextField.placeholder = "R$ 5,00"
          alertTextField.textAlignment = .center
          alertTextField.keyboardType = .numberPad
          alertTextField.addTarget(self, action: #selector(self.myTextFieldDidChange), for: .editingChanged)
          valor = alertTextField
      }
      
      alert.addAction(createAction)
      alert.addAction(cancelAction)
      
      present(alert, animated: true, completion: nil)
      
  }

  func getDoubleValue(value: String) -> Double {

    var cleanedAmount = ""
    var result: Double = 0.0

    for character in value {
      if character.isNumber {
        cleanedAmount.append(character)
      }
    }

    let amount = Double(cleanedAmount) ?? 0.0
    result = (amount / 100.0)

    return result
  }

  override func viewDidLoad() {
    super.viewDidLoad()

      if target != nil {
          self.descricaoTarget.text = target.descricao
          
          let valorFinal = Utils.rounded(valor: target.valorFinal!)
          let tipo = target.tipoValor == 1 ? TypeValue.Real : TypeValue.Dolar
          
          self.valorFinalTarget.text = String(format: "%.2f", valorFinal).currencyInputFormatting(tipo: tipo)
          self.tituloInicial = target.descricao
          self.valorFinalInicial = self.valorFinalTarget.text
          
          listDebit = DebitManager.debitsFromTarget(target: target!)
      }
      
      valorFinalTarget.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
      
      tableViewDebit.delegate = self
      tableViewDebit.dataSource = self
      
      tableViewDebit.reloadData()
  }

  override func viewDidDisappear(_ animated: Bool) {

    super.viewDidDisappear(animated)
  }

  @objc func myTextFieldDidChange(_ textField: UITextField) {
      
      let tipo = target.tipoValor == 1 ? TypeValue.Real : TypeValue.Dolar

      if let amountString = textField.text?.currencyInputFormatting(tipo: tipo) {
      textField.text = amountString
    }
  }

  // MARK: TABELA

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return listDebit.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell =
      tableViewDebit.dequeueReusableCell(withIdentifier: "DebitCell", for: indexPath)
      as! DebitTableViewCell
      
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "dd/MM/YY"
      
      let debit = listDebit[indexPath.row]
      
      let data = debit.createdAt!
      let valor = debit.valor!
      let tipo = debit.tipo == 1 ? TypeValue.Real : TypeValue.Dolar
      
      let valorString = String(format: "%.2f", valor)
      
      print("valor[\(indexPath.row)]: \(valorString)")
      
      cell.dataDebit.text = dateFormatter.string(from: data)
      cell.valueDebit.text = valorString.currencyInputFormatting(tipo: tipo)
    return cell
  }

  func tableView(
    _ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
    forRowAt indexPath: IndexPath
  ) {
      
      if editingStyle == .delete {
          let indice = indexPath.row
          
          DebitManager.deleteDebit(debit: listDebit[indice])
          
          listDebit.remove(at: indice)
          
          tableViewDebit.deleteRows(at: [indexPath], with: .automatic)
      }
  }

}
