//
//  Api.swift
//  target
//
//  Created by Sávio Dutra on 17/12/23.
//

import UIKit

public class Api {
    
    var request: URLRequest?
    var baseURL: String
    var lastErro: String = ""
    
    public static var shared: Api = {
        let instance = Api()
        return instance
    }()
    
    private init() {
        //baseURL = "http://192.168.3.44:3333/"
        baseURL = "http://192.168.3.20:3333/"
    }
    
    public func getLastErro() -> String {
        return lastErro
    }
    
    public func login(userLogin: LoginRequest) async throws -> String {
        
        print("login")
        
        request = URLRequest(url: URL(string: baseURL + "login")!)
        
        request?.httpMethod = "POST"
        request?.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        request?.timeoutInterval = 5000
        
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
        } else {
            let msgErro = try JSONDecoder().decode(ErrorResponse.self, from: data)
            
            lastErro = msgErro.errors[0].message
        }
        
        return session
        
    }
    
    public func signin(userLogin: LoginRequest) async throws -> String {
        
        print("signin")
        
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
    
    public func getAllTarget() async throws -> [Target] {
        
        print("getAllTarget")
        
        request = URLRequest(url: URL(string: baseURL + "all")!)
        request?.httpMethod = "GET"
        request?.setValue("\(KeysStorage.shared.token!)", forHTTPHeaderField: "Cookie")
        
        let (data, response) = try await URLSession.shared.data(for: request!)
        
        return try JSONDecoder().decode([Target].self, from: try mapResponse(response: (data, response)))
    }
    
    public func getAllDeposity(targetId: Int) async throws -> [Deposit] {
        
        print("getAllDeposity")
        
        request = URLRequest(url: URL(string: baseURL + "deposit/\(targetId)")!)
        
        request?.httpMethod = "GET"
        request?.setValue("\(KeysStorage.shared.token!)", forHTTPHeaderField: "Cookie")
        
        let (data, response) = try await URLSession.shared.data(for: request!)
        
        return try JSONDecoder().decode([Deposit].self, from: try mapResponse(response: (data, response)))
    }
    
    public func removeTarget(targetId: Int) async throws {
        
        print("removeTarget")
        
        request = URLRequest(url: URL(string: baseURL + "target/\(targetId)")!)
        
        request?.httpMethod = "DELETE"
        request?.setValue("\(KeysStorage.shared.token!)", forHTTPHeaderField: "Cookie")
        
        let (_, _) = try await URLSession.shared.data(for: request!)
    }
    
    public func addTarget(target: Target) async throws -> Target {
        
        print("addTarget")
        
        request = URLRequest(url: URL(string: baseURL + "target")!)
        
        request?.httpMethod = "POST"
        //let contentHeader = target.imagem.contains(" ") ? "application/json" : "multipart/form-data; application/json"
        let contentHeader = "application/json"
        request?.setValue(contentHeader, forHTTPHeaderField: "Content-type")
        request?.setValue("\(KeysStorage.shared.token!)", forHTTPHeaderField: "Cookie")
        
        let encoded = try JSONEncoder().encode(target)
        
        let (data, response) = try await URLSession.shared.upload(for: request!, from: encoded)
        
        let debug = String(decoding: data, as: UTF8.self)
        //print("add res: \(debug)")
        
        let result: Target = try JSONDecoder().decode(Target.self, from: try mapResponse(response: (data, response)))
        
        KeysStorage.shared.recarregar = true
        
        return result
    }
    
    public func editTarget(target: Target) async throws -> Target {
        
        print("editTarget")
        
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
    
    public func deposit(amount: Double) async throws {
        
        print("deposit")
        
        request = URLRequest(url: URL(string: baseURL + "inside")!)
        request?.httpMethod = "POST"
        request?.setValue("application/json", forHTTPHeaderField: "Content-type")
        request?.setValue("\(KeysStorage.shared.token!)", forHTTPHeaderField: "Cookie")
        
        let encoded = Data("{\"valor\":\(amount)}".utf8)
        
        let (_, _) = try await URLSession.shared.upload(for: request!, from: encoded)
        
        KeysStorage.shared.recarregar = true
    }
    
    public func getDetailImage(idTarget: Int) async -> ImageTarget {
        
        do {
            request = URLRequest(url: URL(string: baseURL + "imagens/\(idTarget)/details")!)
            request?.httpMethod = "GET"
            request?.setValue("\(KeysStorage.shared.token!)", forHTTPHeaderField: "Cookie")
            
            let (data, response) = try await URLSession.shared.data(for: request!)
            
            return try JSONDecoder().decode(ImageTarget.self, from: try mapResponse(response: (data, response)))
        } catch {
            print("getDetailImage \(idTarget): \(error)")
        }
        
        return ImageTarget(id: nil, idTarget: nil, updatedAt: nil, imagem: nil)
    }
    
    public func getImage(idTarget: Int) async throws -> ImageTarget {
        
        print("getImage")
        
        do {
            request = URLRequest(url: URL(string: baseURL + "imagens/\(idTarget)/image")!)
            request?.httpMethod = "GET"
            request?.setValue("\(KeysStorage.shared.token!)", forHTTPHeaderField: "Cookie")
            
            let (data, response) = try await URLSession.shared.data(for: request!)
            
            return try JSONDecoder().decode(ImageTarget.self, from: try mapResponse(response: (data, response)))
        } catch {
            print("getDetailImage \(idTarget): \(error)")
        }
        
        return ImageTarget(id: nil, idTarget: nil, updatedAt: nil, imagem: nil)
    }
    
    public func changeImage(idTarget: Int, image: String) async throws {
        
        print("changeImage")
        
        request = URLRequest(url: URL(string: baseURL + "imagens/\(idTarget)")!)
        
        request?.httpMethod = "PUT"
        let contentHeader = "application/json"
        request?.setValue(contentHeader, forHTTPHeaderField: "Content-type")
        request?.setValue("\(KeysStorage.shared.token!)", forHTTPHeaderField: "Cookie")
        
        // Criando o JSON como dicionário
        let body: [String: Any] = [
            "imagem": image
        ]
        
        // Convertendo o dicionário para JSON Data
        let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
        
        // Enviando a requisição usando URLSession
        let (data, _) = try await URLSession.shared.upload(for: request!, from: jsonData)
        
        // Convertendo a resposta para string (opcional)
        _ = String(decoding: data, as: UTF8.self)
    }
    
    public func infoUser() async throws -> String {
        
        print("infoUser")
        
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
    
    public func getHistoricUser() async throws -> [Deposit] {
        
        print("getHistoricUser")
        
        do {
            request = URLRequest(url: URL(string: baseURL + "historic")!)
            request?.httpMethod = "GET"
            request?.setValue("\(KeysStorage.shared.token!)", forHTTPHeaderField: "Cookie")
            
            let (data, response) = try await URLSession.shared.data(for: request!)
            
            return  try JSONDecoder().decode([Deposit].self, from: try mapResponse(response: (data, response)))
        } catch {
            return []
        }
    }
    
    public func comprar(idTarget: Int) async throws {
        
        print("comprar")
        request = URLRequest(url: URL(string: baseURL + "comprar/\(idTarget)/1")!)
        
        request?.httpMethod = "PUT"
        request?.setValue("\(KeysStorage.shared.token!)", forHTTPHeaderField: "Cookie")
        
        let (_, _) = try await URLSession.shared.data(for: request!)
    }
}
