//
//  GFTextElementConfig.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 08/05/21.
//

import UIKit

extension GFTextElement {
    
    /// Serializable Configuration specific for the GFTextElement.
    public struct Configuration: Codable {
        var fontName: String? = nil
        var fontSize: CGFloat = 16
        var textColor: GFColor = UIColor.black.gfColor
        var text: String = "Text"
    }
}

