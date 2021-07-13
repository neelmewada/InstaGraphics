//
//  EditorToolBarItem.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 29/05/21.
//

import UIKit
import GraphicsFramework

final class EditorToolBarItem: NSObject {
    var icon: UIImage?
    var tintColor: UIColor
    var action: GFAction
    var popupConfig: EditorToolBarPopup.Configuration
    var tapBehaviour: TapBehaviour
    
    enum TapBehaviour {
        case openPopup
        case performAction
    }
    
    var controls: [EditorToolBarPopup.ControlBuilder] = []
    
    init(icon: UIImage?,
         tintColor: UIColor,
         action: GFAction,
         tapBehaviour: TapBehaviour = .performAction,
         popupConfig: EditorToolBarPopup.Configuration = .init()) {
        
        self.icon = icon
        self.tintColor = tintColor
        self.action = action
        self.popupConfig = popupConfig
        self.tapBehaviour = tapBehaviour
    }
    
    func popupControls(_ builder: EditorToolBarPopup.ControlBuilder...) {
        self.controls = builder
    }
}


// MARK: - Predefined ToolBar Items

extension EditorToolBarItem {
    
    static var deleteItem: EditorToolBarItem {
        let item = EditorToolBarItem(icon: UIImage(named: "delete-icon"),
                                     tintColor: .brandRedDelete,
                                     action: GFActionDelete(),
                                     tapBehaviour: .openPopup)
        item.popupControls(.label("Delete", color: .brandRedDelete))
        return item
    }
    
    static var duplicateItem: EditorToolBarItem {
        let item = EditorToolBarItem(icon: UIImage(named: "duplicate-icon"),
                                     tintColor: .white,
                                     action: GFActionDuplicate())
        item.popupControls(.label("Duplicate"))
        return item
    }
    
}

