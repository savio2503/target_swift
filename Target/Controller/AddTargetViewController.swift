//
//  AddTargetViewController.swift
//  Target
//
//  Created by Sávio Dutra on 03/10/22.
//

import CoreData
import UIKit

class AddTargetViewController: UIViewController {

  var context: NSManagedObjectContext!

  @IBOutlet weak var descricaoTarget: UITextField!
  @IBOutlet weak var valorInicialText: UITextField!
  @IBOutlet weak var valorFinalText: UITextField!

  @IBAction func salvarBtn(_ sender: Any) {
      let valorInicial = getDoubleValue(value: valorInicialText.text)
      let valorFinal = getDoubleValue(value: valorFinalText.text)
      let descricao = descricaoTarget.text
      
      if descricao == nil || descricao?.isEmpty ?? false {
          self.showMessage(title: "Atenção", message: "A descrição do objetivo deve ser preenchido")
          return
      }
      
      if valorFinal == 0.0 {
          self.showMessage(title: "Atenção", message: "O valor do objetivo deve ser preenchido")
          return
      }
      
      print("chamando a funcao para salvar")
      //salvarTarget(descricao: descricao!, inicial: valorInicial, final: valorFinal)
      TargetManager.createTarget(descricao: descricao!, valorInicial: valorInicial, valorFinal: valorFinal)
      
      self.navigationController?.popViewController(animated: true)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
      
      valorInicialText.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
      valorFinalText.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
  }

  func getDoubleValue(value: String?) -> Double {

    var cleanedAmount = ""
    var result: Double = 0.0

    for character in value ?? "" {
      if character.isNumber {
        cleanedAmount.append(character)
      }
    }

    let amount = Double(cleanedAmount) ?? 0.0
    result = (amount / 100.0)

    return result
  }

  @objc func myTextFieldDidChange(_ textField: UITextField) {

    if let amountString = textField.text?.currencyInputFormatting() {
      textField.text = amountString
    }
  }

}
