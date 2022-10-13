//
//  CriarViewController.swift
//  Target
//
//  Created by Sávio Dutra on 03/10/22.
//

import ParseSwift
import UIKit

class CriarViewController: UIViewController {

  @IBOutlet weak var nome: UITextField!
  @IBOutlet weak var email: UITextField!
  @IBOutlet weak var senha1: UITextField!
  @IBOutlet weak var senha2: UITextField!
  @IBOutlet weak var btnSignup: UIButton!

  @IBAction func signup(_ sender: Any) {

    if self.nome.text == nil || self.nome.text!.isEmpty {
      showMessage(title: "Erro!", message: "Campo nome de usuario deve ser preenchida!")
      return
    }
    if self.email.text == nil || self.email.text!.isEmpty {
      showMessage(title: "Erro!", message: "Campo e-mail deve ser preenchida!")
      return
    }
    if self.senha1.text == nil || self.senha1.text!.isEmpty {
      showMessage(title: "Erro!", message: "Campo senha deve ser preenchida!")
      return
    }
    if self.senha2.text == nil || self.senha2.text!.isEmpty || self.senha2.text != self.senha1.text
    {
      showMessage(title: "Erro!", message: "Senha de confirmação está diferente!")
      return
    }

      let newUser = User(
      username: self.nome.text!, email: self.email.text!, password: self.senha1.text!)

    do {
        _ = try newUser.signup()
      //showMessage(title: "Sucesso!", message: "Cadastro realizado com sucesso!")
        
        UserManager.manager.user = newUser

        //chamar tela
        performSegue(withIdentifier: "sign_main", sender: nil)
    } catch let error as ParseError {
      showMessage(title: "Error", message: error.message)
    } catch {
      showMessage(title: "Error", message: error.localizedDescription)
    }

  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.dismissKeyboard()
    // Do any additional setup after loading the view.
  }

  /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
