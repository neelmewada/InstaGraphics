//
//  GFElementInfo.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 05/05/21.
//

import Foundation
import UIKit

/// The serialized version of any GFElement subclass.
public struct GFCodableElement: Codable {
    // MARK: - General Properties
    
    let id: String
    
    var elementType: GFElementType
    
    /// Position with respect to the parent.
    var position: CGPoint
    
    /// Size of the element with respect to current document resolution.
    var size: CGSize
    
    var rotation: CGFloat
    
    var background: GFCodableBackground
    
    var children: [GFCodableElement] = []
    
    // MARK: - GFTextElement Properties
    
    var textConfig: GFTextElement.Configuration = .init()
    
    // MARK: - GFImageElement Properties
    
    
    
    // MARK: - Helpers
    
    /// Creates and returns an empty Element.
    public static var none: GFCodableElement {
        return GFCodableElement(id: "", elementType: .none, position: .zero, size: .zero, rotation: 0, background: .clear)
    }
    
    
    /// Creates a Serialized version of the given element.
    /// - Parameter element: The original element.
    /// - Returns: Returns the serialized element. i.e. GFCodableElement.
    public static func create(from element: GFElement) -> GFCodableElement {
        
        var textConfig = GFTextElement.Configuration()
        if let textElement = element as? GFTextElement {
            textConfig = textElement.getConfiguration()
        }
        
        return GFCodableElement(id: element.id,
                                elementType: element.type,
                                position: element.originalFrame.origin,
                                size: element.originalFrame.size,
                                rotation: element.rotation,
                                background: element.background.serializedValue,
                                textConfig: textConfig)
    }
    
    // MARK: - Operators
    
    
}

public enum GFElementType: Int, Codable, CaseIterable {
    case none
    case canvas
    case image
    case text
    case shape
    case gradient
}

