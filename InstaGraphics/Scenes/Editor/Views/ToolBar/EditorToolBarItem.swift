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
    var attributes: [Attribute]
    var action: GFAction
    
    typealias Attribute = EditorToolBarPopupAttribute
    //typealias PopupConfig = EditorToolBarPopupView.Configuration
    
    public init(icon: UIImage?, tintColor: UIColor, attrs: [Attribute], action: GFAction) {
        self.icon = icon
        self.tintColor = tintColor
        self.attributes = attrs
        self.action = action
    }
}


// MARK: - Predefined ToolBar Items

extension EditorToolBarItem {
    
    static var deleteItem: EditorToolBarItem {
        return EditorToolBarItem(icon: UIImage(named: "delete-icon"),
                                 tintColor: kPrimaryRedColor,
                                 attrs: [.minWidth],
                                 action: GFActionDelete())
    }
    
    static var duplicateItem: EditorToolBarItem {
        return EditorToolBarItem(icon: UIImage(named: "duplicate-icon"),
                                 tintColor: .white,
                                 attrs: [.minWidth],
                                 action: GFActionDuplicate())
    }
    
}

