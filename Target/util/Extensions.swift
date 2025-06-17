//
//  Extensions.swift
//  target
//
//  Created by Sávio Dutra on 25/05/25.
//

#if !os(macOS)
import UIKit

extension UIApplication {
    func topMostViewController(base: UIViewController? = UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow } .first?.rootViewController) async -> UIViewController? {
        if let nav = base as? UINavigationController {
            return await topMostViewController(base: nav.visibleViewController)
        }

        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return await topMostViewController(base: selected)
            }
        }

        if let presented = base?.presentedViewController {
            return await topMostViewController(base: presented)
        }

        return base
    }
}
#endif
