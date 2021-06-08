//
//  GFBackgroundInfo.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 05/05/21.
//

import Foundation
import UIKit

public struct GFCodableBackground: Codable {
    var type: GFBackgroundType = .clear
    var image: GFCodableImage = .empty
    var color: GFColor = .clear
    var gradient: GFGradient = .empty
    
    /// The overall opacity that is multiplied to the background.
    var opacity: CGFloat = 1.0
    
    public static var clear: GFCodableBackground {
        return GFCodableBackground(type: .clear, opacity: 0.0)
    }
}

public enum GFBackgroundType: Int, Codable {
    case color
    case gradient
    case image
    case clear
}

