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
    
    @objc
    func createToolBarItems(_ toolBar: EditorToolBar) -> [EditorToolBarItem] {
        var items = super.createDefaultToolBarItems()
        
        let imageItem = EditorToolBarItem(icon: UIImage(named: "image-icon"),
                                          tintColor: .white,
                                          action: GFActionCustom({ input in
                                            toolBar.showPhotoPickerPopup(for: input)
                                            return input
                                          }))
        imageItem.popupControls(.label("Replace Image"))
        items.append(imageItem)
        
        return items
    }
    
}

