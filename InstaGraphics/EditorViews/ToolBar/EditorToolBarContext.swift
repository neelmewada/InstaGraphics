//
//  EditorToolBarContext.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 04/06/21.
//

import UIKit
import GraphicsFramework

@objc protocol EditorToolBarContext {
    
    @objc func createToolBarItems() -> [EditorToolBarItem]
    
}

// MARK: - GFElement Context

/// The ToolBar context for GFElement base class.
extension GFElement {
    
    @objc func createDefaultToolBarItems() -> [EditorToolBarItem] {
        var items = [EditorToolBarItem]()
        if self.type == .none {
            fatalError("ERROR! Found a GFElement of type none\n \(self)")
        }
        
        // Delete Item
        if self.type != .canvas {
            items.append(.deleteItem)
        }
        
        // Duplicate Item
        if self.type != .canvas {
            items.append(.duplicateItem)
        }
        
        for _ in 1...5 {
            items.append(.duplicateItem)
        }
        
        return items
    }
    
}
