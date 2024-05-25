import UIKit

struct RuntimeError: LocalizedError {
    let description: String

    init(_ description: String) {
        self.description = description
    }

    var errorDescription: String? {
        description
    }
}


func convertImageToBase64(urlString: String) -> String? {
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        return nil
    }
    
    guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
        print("Failed to load image from URL:", urlString)
        return nil
    }
    
    let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 300, height: 300))
    
    if let base64String = resizedImage.jpegData(compressionQuality: 1)?.base64EncodedString() {
        return base64String
    } else {
        print("Failed to convert image to base64")
        return nil
    }
}

func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size
    
    let widthRatio = targetSize.width / size.width
    let heightRatio = targetSize.height / size.height
    
    var newSize: CGSize
    if widthRatio > heightRatio {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    }
    
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage ?? image
}

func callRemoveBackgroundService(imageData: Data) async -> UIImage? {
    let url = URL(string: "http://192.168.3.19:5001/upload")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("image/webp", forHTTPHeaderField: "Content-Type")
    request.httpBody = imageData
    
    var result: UIImage?
    
    do {
        let (data, _) = try await URLSession.shared.data(for: request)
        if let receivedImage = UIImage(data: data) {
            result = receivedImage
        } else {
            print("Failed to convert received data to image")
        }
    } catch {
        print("Error sending image data to web service:", error)
    }
        
    return result
}

func cutImage(image: UIImage) -> UIImage? {
    
    let size = CGSize(width: image.size.width, height: image.size.height)
    
    UIGraphicsBeginImageContextWithOptions(size, false, image.scale)
    
    defer {
        UIGraphicsEndImageContext()
    }
    
    guard let context = UIGraphicsGetCurrentContext() else { return nil }
    
    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    
    image.draw(in: rect)
    
    context.setBlendMode(.copy)
    context.setAlpha(1.0)
    context.setFillColor(UIColor.white.cgColor)
    context.fill(rect)
    
    image.draw(at: .zero, blendMode: .normal, alpha: 1.0)
    
    guard let outputImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
    
    return outputImage
    
}

func removex(source: String) async throws -> String? {
    
    var aux: String?
    
    if source.count > 5 && source.substring(to: 5).contains("http") {
        aux = convertImageToBase64(urlString: source)
    } else if !source.contains(" ") {
        aux = source
    } else {
        return nil
    }
    
    var imageSource: UIImage?
    
    if let imageData = Data(base64Encoded: aux!), let image = UIImage(data: imageData) {
        imageSource = image
    } else {
        print("Failed to convert Base64 string to image data")
        return nil
    }
    
    //chamando o servico para removacao
    guard let imageData = imageSource!.pngData() else {
        print("Failed to convert imagedata to data")
        throw RuntimeError("Failed to convert imagedata to data")
    }
    
    guard let imageWithoutBackground = await callRemoveBackgroundService(imageData: imageData) else {
        print("Erro no envio do webservice")
        throw RuntimeError("Erro no envio do webservice")
    }
    
    guard let imageCuted = cutImage(image: imageWithoutBackground) else {
        print("Erro ao cortar a imagem")
        throw RuntimeError("Erro ao cortar a imagem")
    }
    
    guard let cutedBase64 = imageCuted.pngData()?.base64EncodedString() else {
        print("Erro ao converter a imagem cortada em base64")
        throw RuntimeError("Erro ao converter a imagem cortada em base64")
    }
    
    
    return cutedBase64
}

var result: String?

do {
    result = try await removex(source: "https://s2-techtudo.glbimg.com/SSAPhiaAy_zLTOu3Tr3ZKu2H5vg=/0x0:1024x609/888x0/smart/filters:strip_icc()/i.s3.glbimg.com/v1/AUTH_08fbf48bc0524877943fe86e43087e7a/internal_photos/bs/2022/c/u/15eppqSmeTdHkoAKM0Uw/dall-e-2.jpg")
} catch {
    print("\(error.localizedDescription)")
}

if result != nil {
    print("result: \(String(describing: result?.substring(to: 10)))")
} else {
    print("imagem result null")
}

print("finish")
