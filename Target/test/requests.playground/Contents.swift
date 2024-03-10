import UIKit

extension URLResponse {
    func headerField(forKey key: String) -> String? {
        (self as? HTTPURLResponse)?.allHeaderFields[key] as? String
    }
}

var request = URLRequest(url: URL(string: "http://192.168.0.192:3333/login")!)

request.httpMethod = "POST"
request.setValue("application/json", forHTTPHeaderField: "Content-Type")

//let encoded = try JSONEncoder().encode("{\"password\":\"123456\",\"email\":\"user@mail.com\"}")

let encoded = Data("{\"password\":\"123456\",\"email\":\"user@mail.com\"}".utf8)

var (data, response) = try await URLSession.shared.upload(for: request, from: encoded)

print(String(decoding: data, as: UTF8.self))
//print("cookie: \(response.headerField(forKey: "Set-Cookie") ?? "nao pegou")")

let cookie = response.headerField(forKey: "Set-Cookie") ?? ""
let pattern = "SameSite=([^;]+),([^;]+)"
var result = ""

if let regex = try? NSRegularExpression(pattern: pattern) {
    let matches = regex.matches(in: cookie, range: NSRange(cookie.startIndex..., in: cookie))
    let matchStrings = matches.map { match in
        String(cookie[Range(match.range(at: 2), in: cookie)!])
    }
    result = matchStrings.joined(separator: ";")
}
print("source: \(cookie)")
print("\n")
print("cookie: \(result)")

request = URLRequest(url: URL(string: "http://192.168.0.192:3333/all")!)

request.httpMethod = "GET"
request.setValue(result, forHTTPHeaderField: "Cookie")

(data, response) = try await URLSession.shared.data(for: request)

print("get target -> \(String(decoding: data, as: UTF8.self).prefix(50))")
