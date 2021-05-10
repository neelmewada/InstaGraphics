//
//  GFBackgroundInfo.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 05/05/21.
//

import Foundation
import UIKit

public struct GFBackgroundInfo: Codable {
    var type: GFBackgroundType = .clear
    var image: GFImageInfo = GFImageInfo(urls: [])
    var color: GFColor = GFColor()
    var gradient: GFGradient = GFGradient()
    
    /// The overall opacity that is multiplied to the background.
    var opacity: CGFloat = 1.0
    
    public static var clear: GFBackgroundInfo {
        return GFBackgroundInfo(type: .clear, opacity: 0.0)
    }
}

public enum GFBackgroundType: Int, Codable {
    case color
    case gradient
    case image
    case clear
}

