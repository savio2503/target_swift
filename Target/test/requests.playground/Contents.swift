import UIKit

struct ErrorLogin: Codable, Hashable, Identifiable {
    let id: Int?
    let erros: [Message]
}

struct Message: Codable, Hashable, Identifiable {
    let id: Int?
    let message: String
}

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

var request: URLRequest?
var baseURL: String = "http://192.168.3.20:3333/"


request = URLRequest(url: URL(string: baseURL + "login")!)

request?.httpMethod = "POST"
request?.setValue("application/json", forHTTPHeaderField: "Content-type")

let encoded = try JSONEncoder().encode("{\"email\":\"user1@mail.com\",\"password\":\"12345678\"}")

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
    let msgErro = try JSONDecoder().decode(ErrorLogin.self, from: try mapResponse(response: (data, response)))
    
    print(msgErro)
}


print(session)
