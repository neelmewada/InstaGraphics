//
//  EditorToolBarPopup+ControlBuilder.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 10/07/21.
//

import UIKit

extension EditorToolBarPopup {
    
    struct ControlBuilder {
        var view: UIView? = nil
        var selectable: Bool = false
        var spacing: CGFloat? = nil
        var action: (() -> Void)? = nil
        
        // MARK: - Components
        
        static func label(_ text: String,
                          color: UIColor = .white,
                          fontName: String? = nil,
                          fontSize: CGFloat = 14,
                          spacingAfter: CGFloat? = nil,
                          selectable: Bool = true) -> ControlBuilder {
            let label = UILabel()
            label.text = text
            label.textColor = color
            if let fontName = fontName {
                label.font = UIFont(name: fontName, size: fontSize)
            } else {
                label.font = .systemFont(ofSize: fontSize)
            }
            return ControlBuilder(view: label, selectable: selectable, spacing: spacingAfter)
        }
        
        
        
    }
    
}
