//
//  GFDocument.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 06/05/21.
//

import UIKit

public class GFDocument {
    var resolution: CGSize
    var background: GFCodableBackground = GFCodableBackground()
    var elements: [GFCodableElement] = []
    
    private init(_ resolution: CGSize) {
        self.resolution = resolution
    }
    
    // MARK: - Helper Methods
    
    public static func create(withResolution res: CGSize) -> GFDocument {
        return GFDocument(res)
    }
    
    public func getCodableDocument() -> GFCodableDocument {
        return GFCodableDocument.create(fromDocument: self)
    }
}
