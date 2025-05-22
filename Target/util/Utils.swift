//
//  Utils.swift
//  target
//
//  Created by Sávio Dutra on 31/12/23.
//

#if os(macOS)
import AppKit
#endif
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

func getGridRows() -> [GridItem] {
    let adaptiveGridItem = GridItem(.adaptive(minimum: 160))
    return Array(repeating: adaptiveGridItem, count: getNumberOfColumns())
}

func getNumberOfColumns() -> Int {
    
#if os(macOS)
    let windowWidth = NSApplication.shared.windows.first?.frame.width ?? 300
    let columns = Int( (windowWidth - 250) / 170)
#else
    let windowWidth = UIScreen.main.bounds.width
    //print("windowsWidth \(windowWidth)")
    let columns = Int(windowWidth / 170)
#endif
    return max(columns, 1)
}

func dateFormat(text: String) -> String {
    
    let dateFormatter = DateFormatter()
    
    let datas = text.replacing("T", with: " ").substring(to: 16)
    
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    let data = dateFormatter.date(from: datas)!
    
    dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
    
    return dateFormatter.string(from: data)
}

extension Double {
    func toCurrency() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: self))
    }
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
    
    func substring(from start: Int, length: Int) -> String {
        guard start >= 0, length >= 0, start < self.count else { return "" }
        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex = self.index(startIndex, offsetBy: min(length, self.count - start))
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

#if !os(macOS)

extension UIScreen {
    static let screenWith = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}

extension UIImage {
    
    func resizeToFill() -> UIImage? {
        
        let newSize: CGSize
        let maxSize: CGFloat = 900
        let aspectRatio = size.width / size.height
        
        if size.width > size.height {
            newSize = CGSize(width: maxSize, height: maxSize / aspectRatio)
        } else {
            newSize = CGSize(width: maxSize * aspectRatio, height: maxSize)
        }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: newSize))
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
#else
extension NSImage {
    
    func pngData() -> Data? {
        guard let tiffData = self.tiffRepresentation,
              let bitmapImage = NSBitmapImageRep(data: tiffData) else {
            return nil
        }
        
        return bitmapImage.representation(using: .png, properties: [:])
    }
    
    func resizeToFill() -> NSImage? {
        let maxSize: CGFloat = 900
        let aspectRatio = size.width / size.height
        let newSize: CGSize
        
        if size.width > size.height {
            newSize = CGSize(width: maxSize, height: maxSize / aspectRatio)
        } else {
            newSize = CGSize(width: maxSize * aspectRatio, height: maxSize)
        }
        
        let newImage = NSImage(size: newSize)
        newImage.lockFocus()
        defer { newImage.unlockFocus() }
        
        self.draw(in: CGRect(origin: .zero, size: newSize),
                  from: NSRect(origin: .zero, size: self.size),
                  operation: .copy,
                  fraction: 1.0)
        
        return newImage
    }
}

extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get{.none}
        set{}
    }
}

extension NSView {
    func removeFocusRing() {
        if let textField = self as? NSTextField {
            textField.focusRingType = .none
        } else if let button = self as? NSButton {
            button.focusRingType = .none
        }
    }
}
#endif


// Função auxiliar para formatar a porcentagem
func formattedPorcentagem(_ value: Double?) -> String {
    guard let value = value else { return "0.00%" }
    return String(format: "%.2f%%", value)
}
