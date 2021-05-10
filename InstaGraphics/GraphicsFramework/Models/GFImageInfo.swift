//
//  GFImageInfo.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 05/05/21.
//

import Foundation
import UIKit

public struct GFImageInfo: Codable {
    /// Urls of this image ordered by increasing image resolution. Further the url in this array, higher it's resolution.
    var urls: [String]
    
    /// Indicates whether the urls represent a local image, remote image or asset name
    var mode: GFImageMode = .remote
    
    public static var empty: GFImageInfo {
        return GFImageInfo(urls: [])
    }
    
    public static func create(withMode mode: GFImageMode, urls: [String]) -> GFImageInfo {
        return GFImageInfo(urls: urls, mode: mode)
    }
}

public enum GFImageMode: Int, Codable {
    case remote
    case local
    case asset
}
