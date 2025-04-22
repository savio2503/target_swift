//
//  ImageCacheManager.swift
//  ComponentsCommunication
//
//  Created by Sávio Dutra on 20/04/25.
//

import UIKit

public final class ImageCacheManager {
    public static let shared = ImageCacheManager()
    
    private let cache = NSCache<NSNumber, UIImage>()
    
    public func image(for id: Int) -> UIImage? {
        return cache.object(forKey: NSNumber(value: id))
    }
    
    public func setImage(_ image: UIImage, for id: Int) {
        cache.setObject(image, forKey: NSNumber(value: id))
    }
}
