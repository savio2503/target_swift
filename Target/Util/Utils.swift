//
//  Utils.swift
//  Target
//
//  Created by Sávio Dutra on 09/10/22.
//

import Foundation
import UIKit

class Utils {

    static func rounded(valor: Double) -> Double {
        return Double(round(100 * valor) / 100)
    }
    
    static func doubleToCurrency(value: Double) -> String {
        
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "R$"
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

  func currencyInputFormatting() -> String {

    let formatter = NumberFormatter()
    formatter.numberStyle = .currencyAccounting
    formatter.currencySymbol = "R$"
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
