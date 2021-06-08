//
//  GFDocument.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 05/05/21.
//

import Foundation
import UIKit

public struct GFCodableDocument: Codable {
    var resolution: CGSize
    var background: GFCodableBackground = GFCodableBackground()
    var elements: [GFCodableElement] = []
    
    private init(_ resolution: CGSize) {
        self.resolution = resolution
    }
    
    // MARK: - Helper Methods
    
    public static func create(withResolution res: CGSize) -> GFCodableDocument {
        return GFCodableDocument(res)
    }
    
    public static func create(fromDocument document: GFDocument) -> GFCodableDocument {
        let doc = GFCodableDocument(document.resolution)
        return doc
    }
}

