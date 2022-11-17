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
    
    private var _typeInit: TypeValue!
    private var _typeFins: TypeValue!

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
      
      TargetManager.createTarget(descricao: descricao!, valorInicial: valorInicial, tipoInicial: _typeInit, valorFinal: valorFinal, tipoFinal: _typeFins) { (result) -> () in self.close(success: result)}
      
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
      
      valorInicialText.addTarget(self, action: #selector(myTextFieldDidChangeIni), for: .editingChanged)
      valorFinalText.addTarget(self, action: #selector(myTextFieldDidChangeFin), for: .editingChanged)
      
      createSpaceTypeMenu()
      
      
      _typeInit = TypeValue.Real
      _typeFins = TypeValue.Real
      
  }

  @objc func myTextFieldDidChangeIni(_ textField: UITextField) {
      
      if let amountString = textField.text?.currencyInputFormatting(tipo: self._typeInit) {
      textField.text = amountString
    }
  }
    
    @objc func myTextFieldDidChangeFin(_ textField: UITextField) {
        
        if let amountString = textField.text?.currencyInputFormatting(tipo: self._typeFins) {
        textField.text = amountString
      }
    }
    
//MARK: - MENU TYPE
    
    private var spaceTypeMenuItemsIni: [UIAction] {
        return [
            UIAction(title: "Real", handler: { (_) in self._typeInit = TypeValue.Real }),
            UIAction(title: "Dolar", handler: { (_) in self._typeInit = TypeValue.Dolar })
        ]
    }
    
    var spaceTypeMenuIni: UIMenu {
        return UIMenu(title: "Tipo da Moeda", image: nil, identifier: nil, options: [], children: spaceTypeMenuItemsIni)
    }
    
    
    private var spaceTypeMenuItemsFin: [UIAction] {
        return [
            UIAction(title: "Real", handler: { (_) in self._typeFins = TypeValue.Real }),
            UIAction(title: "Dolar", handler: { (_) in self._typeFins = TypeValue.Dolar })
        ]
    }
    
    var spaceTypeMenuFin: UIMenu {
        return UIMenu(title: "Tipo da Moeda", image: nil, identifier: nil, options: [], children: spaceTypeMenuItemsFin)
    }
    
    func createSpaceTypeMenu() {
        typeInit.menu = spaceTypeMenuIni
        typeInit.showsMenuAsPrimaryAction = true
        
        typeFinish.menu = spaceTypeMenuFin
        typeFinish.showsMenuAsPrimaryAction = true
    }
    
}
