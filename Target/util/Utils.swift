//
//  Utils.swift
//  target
//
//  Created by Sávio Dutra on 31/12/23.
//

import Foundation
import SwiftUI

func baseButton(text: String, color: Color) -> any View {
    
    return HStack {
        Spacer()
        Text(text)
            .foregroundStyle(.white)
        Spacer()
    }
    .padding()
    .background(color)
    .cornerRadius(5.0)
}

extension UIScreen {
    static let screenWith = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}

func dateFormat(text: String) -> String {
    
    let dateFormatter = DateFormatter()
    
    var datas = text.replacing("T", with: " ").substring(to: 16)
    
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    let data = dateFormatter.date(from: datas)!
    
    dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
    
    return dateFormatter.string(from: data)
}

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
}

struct CurrencyFormatter {
    
    var currencyFormatter: NumberFormatter
    
    init(coin: Int) {
        
        currencyFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale(identifier: coin == 1 ? "pt_BR" : "US")
            return formatter
        }()
        
    }
}
