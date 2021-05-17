//
//  GFImageInfo.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 05/05/21.
//

import Foundation
import UIKit

/// Codable struct used to store information about an image obtained from API (Unsplash, Pexels, etc)
public struct GFImageInfo: Codable {
    /// Urls of this image ordered by increasing image resolution. Further the url in this array, higher it's resolution.
    var urls: [GFImageUrl]
    
    /// Indicates whether the urls represent a local image, remote image or asset name.
    var mode: GFImageMode = .remote
    
    /// The thumbnail URL of this image.
    var thumbnailUrl: GFImageUrl = .empty
    
    /// Empty image.
    public static var empty: GFImageInfo {
        return GFImageInfo(urls: [])
    }
    
    
    /// Creates a new GFImageInfo with the specified mode and URLs.
    /// - Parameters:
    ///   - mode: Denotes whether the image urls represent a bundle asset, or local directory or a remote image url.
    ///   - urls: Collection of URLs of the same image in increasing order of their resolution.
    /// - Returns: Returns the codable GFImageInfo.
    public static func create(withMode mode: GFImageMode, urls: [GFImageUrl]) -> GFImageInfo {
        return GFImageInfo(urls: urls, mode: mode)
    }
    
    
    /// Creates a new GFImageInfo with the specified mode and URLs.
    /// - Parameters:
    ///   - mode: Denotes whether the image urls represent a bundle asset, or local directory or a remote image url.
    ///   - thumbnailUrl: A special URL that represents the thumbnail version of this image.
    ///   - urls: Collection of URLs of the same image in increasing order of their resolution.
    /// - Returns: Returns the codable GFImageInfo.
    public static func create(withMode mode: GFImageMode, thumbnailUrl: GFImageUrl, urls: [GFImageUrl]) -> GFImageInfo {
        return GFImageInfo(urls: urls, mode: mode, thumbnailUrl: thumbnailUrl)
    }
}

public struct GFImageUrl: Codable {
    var url: String
    var imageSize: CGSize
    
    public static var empty: GFImageUrl {
        return GFImageUrl(url: "", imageSize: .zero)
    }
    
    /// Creates a GFImageUrl from a given url string.
    /// - Parameter url: The url string of the image.
    /// - Returns: Returns a GFImageUrl.
    public static func fromString(_ url: String) -> GFImageUrl {
        var size = CGSize.zero
        if let w = url.getQueryStringParameter(param: "w"),
           let h = url.getQueryStringParameter(param: "h") {
            size = CGSize(width: CGFloat(Float(w) ?? 0), height: CGFloat(Float(h) ?? 0))
        }
        return GFImageUrl(url: url, imageSize: size)
    }
}


public enum GFImageMode: Int, Codable {
    case remote
    case local
    case asset
}
