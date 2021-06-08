//
//  GFImageElementConfiguration.swift
//  GraphicsFramework
//
//  Created by Neel Mewada on 03/06/21.
//

import UIKit

extension GFImageElement {
    
    /// Serializable Configuration specific for the GFTextElement.
    public struct Configuration: Codable {
        var image: GFCodableImage = .empty
        var size: CGSize = .zero
        var contentMode: Int = ContentMode.scaleAspectFill.rawValue
    }
}

