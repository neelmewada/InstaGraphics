//
//  GFElementInfo.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 05/05/21.
//

import Foundation
import UIKit

public struct GFElementInfo: Codable {
    var elementType: GFElementType
    
    /// Position with respect to the parent.
    var position: CGPoint
    
    /// Size of the element with respect to current document resolution.
    var size: CGSize
    
    var background: GFBackgroundInfo
    
    var children: [GFElementInfo] = []
    
    
    public static var none: GFElementInfo {
        return GFElementInfo(elementType: .none, position: .zero, size: .zero, background: .clear)
    }
}

public enum GFElementType: Int, Codable {
    case none
    case image
    case text
    case shape
    case gradient
}

