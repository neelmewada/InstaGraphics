//
//  GFImageElementContext.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 04/06/21.
//

import UIKit
import GraphicsFramework

// MARK: - EditorToolBarContext

// ToolBar Context used when an image element is selected
extension GFImageElement: EditorToolBarContext {
    
    @objc func createToolBarItems() -> [EditorToolBarItem] {
        return super.createDefaultToolBarItems()
    }
    
}

