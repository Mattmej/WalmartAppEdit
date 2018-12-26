//
//  ImageCache.swift
//  SamsClub
//

import UIKit

class ImageCache {
    
    private let assetCache = NSCache<NSString, UIImage>()
    static let shared = ImageCache()
    
    private init() {}
    
    func saveAssetImageToCache(identifier: String, image: UIImage) {
        assetCache.setObject(image, forKey: identifier as NSString)
    }
    
    func getAssetImageFromCache(identifier: String) -> UIImage? {
        return assetCache.object(forKey: identifier as NSString)
    }
}
