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
    @IBOutlet weak var typeInit: UIButton!
    @IBOutlet weak var typeFinish: UIButton!

  @IBAction func salvarBtn(_ sender: Any) {
      let valorInicial = Utils.getDoubleValue(value: valorInicialText.text)
      let valorFinal = Utils.getDoubleValue(value: valorFinalText.text)
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
      TargetManager.createTarget(descricao: descricao!, valorInicial: valorInicial, valorFinal: valorFinal) { (result) -> () in self.close(success: result)}
      
  }
    
    func close(success: Bool) {
        if success {
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

  override func viewDidLoad() {
    super.viewDidLoad()
      
      valorInicialText.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
      valorFinalText.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
      
      createSpaceTypeMenu()
      
  }

  

  @objc func myTextFieldDidChange(_ textField: UITextField) {

      if let amountString = textField.text?.currencyInputFormatting(tipo: TypeValue.Real) {
      textField.text = amountString
    }
  }
    
//MARK: - MENU TYPE
    
    private var spaceTypeMenuItems: [UIAction] {
        return [
            UIAction(title: "Real", handler: { (_) in }),
            UIAction(title: "Dolar", handler: { (_) in })
        ]
    }
    
    var spaceTypeMenu: UIMenu {
        return UIMenu(title: "Tipo da Moeda", image: nil, identifier: nil, options: [], children: spaceTypeMenuItems)
    }
    
    func createSpaceTypeMenu() {
        typeInit.menu = spaceTypeMenu
        typeInit.showsMenuAsPrimaryAction = true
        
        typeFinish.menu = spaceTypeMenu
        typeFinish.showsMenuAsPrimaryAction = true
    }
    
}
