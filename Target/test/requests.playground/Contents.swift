import UIKit

public enum NetworkError: Error, LocalizedError {
    
    case missingRequiredFields(String)
    
    case invalidParameters(operation: String, parameters: [Any])
    
    case badRequest
    
    case unauthorized
    
    case paymentRequired
    
    case forbidden
    
    case notFound
    
    case requestEntityTooLarge

    case unprocessableEntity
    
    case http(httpResponse: HTTPURLResponse, data: Data)
    
    case invalidResponse(Data)
    
    case deleteOperationFailed(String)
    
    case network(URLError)
    
    case unknown(Error?)

}

func mapResponse(response: (data: Data, response: URLResponse)) throws -> Data {
    guard let httpResponse = response.response as? HTTPURLResponse else {
        return response.data
    }
    
    switch httpResponse.statusCode {
    case 200..<300:
        return response.data
    case 400:
        throw NetworkError.badRequest
    case 401:
        throw NetworkError.unauthorized
    case 402:
        throw NetworkError.paymentRequired
    case 403:
        throw NetworkError.forbidden
    case 404:
        throw NetworkError.notFound
    case 413:
        throw NetworkError.requestEntityTooLarge
    case 422:
        throw NetworkError.unprocessableEntity
    default:
        throw NetworkError.http(httpResponse: httpResponse, data: response.data)
    }
}

struct LoginResponse: Codable, Hashable {
    let type: String
    let tokem: String
    let expires_at: String
}

struct LoginRequest : Codable {
    let email: String
    let password: String
}

//Singleton
class Api {
    
    var request: URLRequest?
    var baseURL: String
    
    static var shared: Api = {
        let instance = Api()
        return instance
    }()
    
    private init() {
        baseURL = "http://127.0.0.1:3333/"
    }
    
    private func tratarRequest(metodo: String, body: Data?) {
        
        request!.httpMethod = metodo
        request!.httpBody = body
        request!.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    
    /*func send(login: LoginRequest) async throws -> LoginResponse {
        
        let url = URL(string: "")
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        let fetchedData = try JSONDecoder().decode(LoginResponse.self, from: try mapResponse(response: (data,response)))
        
        return fetchedData
    }*/
    
    func login(userLogin: LoginRequest) async throws -> LoginResponse {
        
        request = URLRequest(url: URL(string: baseURL + "login")!)
        
        request?.httpMethod = "POST"
        request?.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        let encoded = try JSONEncoder().encode(userLogin)
        
        let (data, response) = try await URLSession.shared.upload(for: request!, from: encoded)
        
        return try JSONDecoder().decode(LoginResponse.self, from: try mapResponse(response: (data, response)))
        
    }
}

extension Api: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}


var login = LoginRequest(email: "user@mail.com", password: "123456")

var resposta = try await Api.shared.login(userLogin: login)
