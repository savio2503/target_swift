//
//  Api.swift
//  target
//
//  Created by Sávio Dutra on 17/12/23.
//

import UIKit

class Api {
    
    var request: URLRequest?
    var baseURL: String
    
    static var shared: Api = {
        let instance = Api()
        return instance
    }()
    
    private init() {
        baseURL = "http://192.168.1.9:3333/"
    }
    
    func login(userLogin: LoginRequest) async throws -> LoginResponse {
        
        print("login(\(userLogin))")
        
        request = URLRequest(url: URL(string: baseURL + "login")!)
        
        request?.httpMethod = "POST"
        request?.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        let encoded = try JSONEncoder().encode(userLogin)
        
        let (data, response) = try await URLSession.shared.upload(for: request!, from: encoded)
        
        return try JSONDecoder().decode(LoginResponse.self, from: try mapResponse(response: (data, response)))
        
    }
}
