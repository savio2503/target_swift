//
//  targetApp.swift
//  target
//
//  Created by Sávio Dutra on 17/12/23.
//

import SwiftUI

@main
struct targetApp: App {
    
    #if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #else
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    #endif
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
