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
        //baseURL = "http://192.168.1.9:3333/"
        baseURL = "http://100.96.1.2:3333/"
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
    
    func getAllTarget(state: Bool?) async throws -> [Target] {
        
        if (state == nil) {
            request = URLRequest(url: URL(string: baseURL + "all")!)
        } else if (state!) {
            request = URLRequest(url: URL(string: baseURL + "allAtive")!)
        } else if (!state!) {
            request = URLRequest(url: URL(string: baseURL + "allAtive")!)
        }
        
        request?.httpMethod = "GET"
        request?.setValue("Bearer \(KeysStorage.shared.token!)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request!)
        
        return try JSONDecoder().decode([Target].self, from: try mapResponse(response: (data, response)))
    }
    
    func getAllDeposity(targetId: Int) async throws -> [Deposit] {
        
        request = URLRequest(url: URL(string: baseURL + "deposit/\(targetId)")!)
        
        request?.httpMethod = "GET"
        request?.setValue("Bearer \(KeysStorage.shared.token!)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request!)
        
        return try JSONDecoder().decode([Deposit].self, from: try mapResponse(response: (data, response)))
    }
}
