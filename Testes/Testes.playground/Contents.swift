import Foundation
import SwiftSoup

func fetchProductData(urlString: String) {
    
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
        extractData(from: htmlContent)
        
        print("finished")
    }
    task.resume()
}

func extractData(from html: String) {
    do {
        // Parse o HTML
        let document = try SwiftSoup.parse(html)
        
        let divElement = try document.select("div.ui-pdp-price__second-line")
        
        print(divElement)
        
        
    } catch {
        print("Erro ao processar o HTML: \(error)")
    }
}

// Exemplo de uso
/*processURL("https://pt.aliexpress.com/item/1005007655551579.html") { finalURL in
    print("URL final processada: \(finalURL)")
    
    fetchProductData(finalURL)
}*/

fetchProductData(urlString: "https://produto.mercadolivre.com.br/MLB-2668759679-camiseta-infantil-basica-manga-curta-com-bordado-_JM#polycard_client=recommendations_home_crosselling-function-recommendations&reco_backend=crosselling_function&reco_client=home_crosselling-function-recommendations&reco_item_pos=1&reco_backend_type=function&reco_id=52ac6667-b0b6-4bb7-9ee4-cabfbf82a214&c_id=/home/crosselling-function-recommendations/element&c_uid=110aa265-3a2b-4bd5-8689-9ce6ef099d23")

print("finalizou")
