//
//  Urls.swift
//  URLShareExtension
//
//  Created by Sávio Dutra on 26/12/24.
//

import Foundation

func processURL(_ url: String, completion: @escaping (String) -> Void) {
    
    guard let parsedURL = URL(string: url) else {
        print("URL inválida")
        completion(url)
        return
    }
    
    if parsedURL.host == "a.co" || parsedURL.host == "bit.ly" || url.count < 20 {
        // Trata URLs encurtadas
        resolveRedirect(for: url) { resolvedURL in
            if let resolvedURL = resolvedURL {
                completion(resolvedURL)
            } else {
                print("Não foi possível resolver o URL, continuando com o original.")
                completion(url)
            }
        }
    } else {
        // Continua com o fluxo normal para URLs
        print("URL nao encurtada: \(url)")
        completion(url)
    }
}

func resolveRedirect(for url: String, completion: @escaping (String?) -> Void) {
    guard let initialURL = URL(string: url) else {
        print("URL invalida")
        completion(nil)
        return
    }
    
    let sessionConfig = URLSessionConfiguration.default
    sessionConfig.httpShouldSetCookies = false
    let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
    
    var request = URLRequest(url: initialURL)
    request.httpMethod = "GET" // Apenas os cabeçalhos, mais rápido que um GET completo
    
    let task = session.dataTask(with: request) { _, response, error in
        if let error = error {
            print("Erro ao fazer a solicitação: \(error.localizedDescription)")
            completion(nil)
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("Resposta inválida")
            completion(nil)
            return
        }
        
        if (200...399).contains(httpResponse.statusCode) {
            // Não há redirecionamento, URL já final
            completion(httpResponse.url?.absoluteString ?? url)
        } else {
            print("Status HTTP inesperado: \(httpResponse.statusCode)")
            completion(nil)
        }
    }
    task.resume()
}

func fetchProductData(sharedContent: SharedContent, urlString: String, completion: @escaping (String, SharedContent) -> Void) {
    
    guard let url = URL(string: urlString) else {
        print("URL inválida")
        return
    }
    
    // Realiza o GET
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Erro ao realizar o GET: \(error.localizedDescription)")
            return
        }
        
        guard let data = data, let htmlContent = String(data: data, encoding: .utf8) else {
            print("Falha ao carregar o conteúdo da página")
            return
        }
        
        
        // Processa o HTML para extrair os dados
        completion(htmlContent, sharedContent)
        
        print("finished")
    }
    task.resume()
}
