//
//  ImageCacheManager.swift
//  ComponentsCommunication
//
//  Created by Sávio Dutra on 20/04/25.
//

#if canImport(UIKit)
import UIKit
public typealias PlatformImage = UIImage
#elseif canImport(AppKit)
import AppKit
public typealias PlatformImage = NSImage
#endif

public final class ImageCacheManager {
    public static let shared = ImageCacheManager()
    
    private let cache = NSCache<NSNumber, PlatformImage>()
    
    public func image(for id: Int) -> PlatformImage? {
        return cache.object(forKey: NSNumber(value: id))
    }
    
    public func setImage(_ image: PlatformImage, for id: Int) {
        cache.setObject(image, forKey: NSNumber(value: id))
    }
}
