//
//  Utils.swift
//  Target
//
//  Created by Sávio Dutra on 09/10/22.
//

import Foundation
import UIKit

class Utils {
    
    static var _realtodollar: Double = 0.0
    
    static var realtodollar: Double {
        get {
            return _realtodollar
        }
    }

    static func rounded(valor: Double) -> Double {
        return Double(round(100 * valor) / 100)
    }
    
    static func doubleToCurrency(value: Double, tipo: TypeValue) -> String {
        
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = tipo == TypeValue.Real ? "R$" : "U$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        let number = NSNumber(value: value)
        
        guard number != 0 as NSNumber else {
            return formatter.string(from: 0.0)!
        }
        
        return formatter.string(from: number)!
    }
    
    static func getDoubleValue(value: String?) -> Double {

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
    
    func getValueRealToDollar() {
        
        let url = URL(string: "https://economia.awesomeapi.com.br/json/last/BRL-USD")
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            guard let data = data else { return }
            
            let response = String(data: data, encoding: .utf8)!
            
            print(response)
            
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any]
                
                let root = jsonResult!["BRLUSD"] as! [String:Any]
                let value: Double = Double(root["bid"] as! String)!
                
                Utils._realtodollar = value
                
                print("1")
            } catch {
              print(error)
            }
        }
        
        task.resume()
        
    }
}

extension UIViewController {
  func showMessage(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

    alertController.addAction(UIAlertAction(title: "Back", style: .cancel))

    present(alertController, animated: true)
  }

  func dismissKeyboard() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(
      target: self, action: #selector(UIViewController.dismissKeyboardTouchOutside))

    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }

  @objc
  private func dismissKeyboardTouchOutside() {
    view.endEditing(true)
  }
    
    func callMainController() {
        
    }
}

extension String {

    func currencyInputFormatting(tipo: TypeValue) -> String {

    let formatter = NumberFormatter()
    formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = tipo == TypeValue.Real ? "R$" : "U$"
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 2

    var amountWithPrefix = self

    let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
    amountWithPrefix = regex.stringByReplacingMatches(
      in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0),
      range: NSMakeRange(0, self.count), withTemplate: "")

    let double = (amountWithPrefix as NSString).doubleValue
    let number = NSNumber(value: (double / 100))

    guard number != 0 as NSNumber else {
      return ""
    }

    return formatter.string(from: number)!
  }
}
