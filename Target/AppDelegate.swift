//
//  AppDelegate.swift
//  target
//
//  Created by Sávio Dutra on 28/05/25.
//
#if os(macOS)
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    var windowSize: CGSize = .zero
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let window = NSApplication.shared.windows.first {
            self.window = window
            self.window.setContentSize(NSSize(width: 800, height: 600))
            self.windowSize = window.frame.size
        }
    }
}
#else
import Foundation
import UIKit
import Firebase
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        // Inicializa Firebase
        FirebaseApp.configure()
        
        // Inicializa Google Sign-In
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("❌ ClientID não encontrado no GoogleService-Info.plist")
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        return true
    }

    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}
#endif
