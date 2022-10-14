//
//  LoginViewController.swift
//  Target
//
//  Created by Sávio Dutra on 03/10/22.
//

import ParseSwift
import UIKit

class LoginViewController: UIViewController {

  @IBOutlet weak var userTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    //print("viewDidLoad-> \(UserManager.manager.user)")

    if UserManager.manager.user != nil {
        callAfterLoginSuccess()
    }

  }
    
    private func callAfterLoginSuccess() {
        performSegue(withIdentifier: "login_main", sender: nil)
    }
    
    

  @IBAction func handleSignUp(_ sender: Any) {
    guard let user = userTextField.text, let pass = passwordTextField.text else {
      return showMessage(title: "Error", message: "The credentials are not valid.")
    }

    logIn(username: user, password: pass)
  }

  private func logIn(username: String, password: String) {

    /*do {
      let loggedInUser = try User.login(username: username, password: password)

      UserManager.manager.user = loggedInUser

      //chamar tela
        performSegue(withIdentifier: "login_main", sender: nil)
    } catch let error as ParseError {
      showMessage(title: "Error", message: "Failed to log in: \(error.message)")
    } catch {
      showMessage(title: "Error", message: "Failed to log in: \(error.localizedDescription)")
    }*/
      
      User.login(username: username, password: password) { [weak self] result in switch result {
      case .success(let loggedInUser):
          
          UserManager.manager.user = loggedInUser
          
          self?.callAfterLoginSuccess()
          
      case .failure(let error):
          self?.showMessage(title: "Error", message: "Failed to log in: \(error.message)")
      }}

  }

}
