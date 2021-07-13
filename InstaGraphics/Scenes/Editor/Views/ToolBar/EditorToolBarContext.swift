//
//  EditorToolBarContext.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 04/06/21.
//

import UIKit
import GraphicsFramework

/// The context object used by EditorToolBar to populate it's items and other info.
@objc protocol EditorToolBarContext {
    
    @objc func createToolBarItems(_ toolBar: EditorToolBar) -> [EditorToolBarItem]
    
}


/// The default ToolBar items for every element.
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
        
        return items
    }
    
}
