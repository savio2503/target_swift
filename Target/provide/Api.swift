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
        //baseURL = "http://192.168.3.50:3333/"
        //baseURL = "http://192.168.3.19:3333/"
        baseURL = "http://192.168.3.20:3333/"
    }
    
    func login(userLogin: LoginRequest) async throws -> String {
        
        //print("login(\(userLogin))")
        
        request = URLRequest(url: URL(string: baseURL + "login")!)
        
        request?.httpMethod = "POST"
        request?.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        let encoded = try JSONEncoder().encode(userLogin)
        
        let (data, response) = try await URLSession.shared.upload(for: request!, from: encoded)
        
        let result = String(decoding: data, as: UTF8.self)
        var session = ""
        
        if (result.contains("logado com sucesso")) {
            
            let cookie = response.headerField(forKey: "Set-Cookie") ?? ""
            let pattern = "SameSite=([^;]+),([^;]+)"
            
            if let regex = try? NSRegularExpression(pattern: pattern) {
                let matches = regex.matches(in: cookie, range: NSRange(cookie.startIndex..., in: cookie))
                let matchStrings = matches.map { match in
                    String(cookie[Range(match.range(at: 2), in: cookie)!])
                }
                session = matchStrings.joined(separator: ";")
            }
        }
        
        return session
        
    }
    
    func signin(userLogin: LoginRequest) async throws -> String {
        
        //print("Sigin in (\(userLogin)")
        
        request = URLRequest(url: URL(string: baseURL + "signin")!)
        
        request?.httpMethod = "POST"
        request?.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        let encoded = try JSONEncoder().encode(userLogin)
        
        let (data, response) = try await URLSession.shared.upload(for: request!, from: encoded)
        
        let result = String(decoding: data, as: UTF8.self)
        var session = ""
        
        if (result.contains("logado com sucesso")) {
            
            let cookie = response.headerField(forKey: "Set-Cookie") ?? ""
            let pattern = "SameSite=([^;]+),([^;]+)"
            
            if let regex = try? NSRegularExpression(pattern: pattern) {
                let matches = regex.matches(in: cookie, range: NSRange(cookie.startIndex..., in: cookie))
                let matchStrings = matches.map { match in
                    String(cookie[Range(match.range(at: 2), in: cookie)!])
                }
                session = matchStrings.joined(separator: ";")
            }
        }
        
        return session
    }
    
    func getAllTarget() async throws -> [Target] {
        
        request = URLRequest(url: URL(string: baseURL + "all")!)
        request?.httpMethod = "GET"
        request?.setValue("\(KeysStorage.shared.token!)", forHTTPHeaderField: "Cookie")
        
        let (data, response) = try await URLSession.shared.data(for: request!)
        
        return try JSONDecoder().decode([Target].self, from: try mapResponse(response: (data, response)))
    }
    
    func getAllDeposity(targetId: Int) async throws -> [Deposit] {
        
        request = URLRequest(url: URL(string: baseURL + "deposit/\(targetId)")!)
        
        request?.httpMethod = "GET"
        request?.setValue("\(KeysStorage.shared.token!)", forHTTPHeaderField: "Cookie")
        
        let (data, response) = try await URLSession.shared.data(for: request!)
        
        return try JSONDecoder().decode([Deposit].self, from: try mapResponse(response: (data, response)))
    }
    
    
    
    func removeTarget(targetId: Int) async throws {
        
        request = URLRequest(url: URL(string: baseURL + "target/\(targetId)")!)
        
        request?.httpMethod = "DELETE"
        request?.setValue("\(KeysStorage.shared.token!)", forHTTPHeaderField: "Cookie")
        
        let (_, _) = try await URLSession.shared.data(for: request!)
        
        //print("removido \(targetId), com sucesso")
    }
    
    func addTarget(target: Target) async throws -> Target {
        
        request = URLRequest(url: URL(string: baseURL + "target")!)
        
        request?.httpMethod = "POST"
        //let contentHeader = target.imagem.contains(" ") ? "application/json" : "multipart/form-data; application/json"
        let contentHeader = "application/json"
        request?.setValue(contentHeader, forHTTPHeaderField: "Content-type")
        request?.setValue("\(KeysStorage.shared.token!)", forHTTPHeaderField: "Cookie")
        
        let encoded = try JSONEncoder().encode(target)
        
        let (data, response) = try await URLSession.shared.upload(for: request!, from: encoded)
        
        let result: Target = try JSONDecoder().decode(Target.self, from: try mapResponse(response: (data, response)))
        
        KeysStorage.shared.recarregar = true
        
        return result
    }
    
    func editTarget(target: Target) async throws -> Target {
        
        request = URLRequest(url: URL(string: baseURL + "target/\(target.id!)")!)
        
        request?.httpMethod = "PUT"
        //let contentHeader = target.imagem.contains(" ") ? "application/json" : "multipart/form-data; application/json"
        let contentHeader = "application/json"
        request?.setValue(contentHeader, forHTTPHeaderField: "Content-type")
        request?.setValue("\(KeysStorage.shared.token!)", forHTTPHeaderField: "Cookie")
        
        let encoded = try JSONEncoder().encode(target)
        
        let (data, response) = try await URLSession.shared.upload(for: request!, from: encoded)
        
        let result: Target = try JSONDecoder().decode(Target.self, from: try mapResponse(response: (data, response)))
        
        KeysStorage.shared.recarregar = true
        
        return result
    }
    
    func deposit(amount: Double) async throws {
        
        request = URLRequest(url: URL(string: baseURL + "inside")!)
        request?.httpMethod = "POST"
        request?.setValue("application/json", forHTTPHeaderField: "Content-type")
        request?.setValue("\(KeysStorage.shared.token!)", forHTTPHeaderField: "Cookie")
        
        let encoded = Data("{\"valor\":\(amount)}".utf8)
        
        let (_, __) = try await URLSession.shared.upload(for: request!, from: encoded)
        
        KeysStorage.shared.recarregar = true
    }
    
    func changeImage(idTarget: Int, image: String) async throws {
        
    }
    
    func infoUser() async throws -> String {
        
        request = URLRequest(url: URL(string: baseURL + "auth/me")!)
        request?.httpMethod = "GET"
        request?.setValue("\(KeysStorage.shared.token!)", forHTTPHeaderField: "Cookie")
        
        let (data, _) = try await URLSession.shared.data(for: request!)
        
        var result = ""
        
        do {
            if let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let email = jsonDict["email"] as? String {
                result = email 
            }
        } catch {
            print("Erro ao converter o dados de usuario")
        }
        
        return result
    }
    
    func getHistoricUser() async throws -> [Deposit] {
        
        request = URLRequest(url: URL(string: baseURL + "historic")!)
        request?.httpMethod = "GET"
        request?.setValue("\(KeysStorage.shared.token!)", forHTTPHeaderField: "Cookie")
        
        let (data, response) = try await URLSession.shared.data(for: request!)
        
        return  try JSONDecoder().decode([Deposit].self, from: try mapResponse(response: (data, response)))
    }
}
