//
//  UserManager.swift
//  Target
//
//  Created by Sávio Dutra on 03/10/22.
//

import Foundation
import ParseSwift

class UserManager {
    
    static let manager = UserManager()
    
    var user: User?
    
    private init() {
        print("-> init UserManager")
        getCurrentUser()
        print("<- init UserManager")
    }
    
    private func getCurrentUser() {
        
        print("-> getCurrentUser")
        
        user = User.current
        
        print("<- getCurrentUser: \(user)")
    }
}
