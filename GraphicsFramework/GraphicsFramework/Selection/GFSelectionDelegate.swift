//
//  GFSelectionDelegate.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 07/05/21.
//

import UIKit

@objc public protocol GFSelectionDelegate: AnyObject {
    
    @objc optional func selection(_ selection: GFSelection, didChangeFrom initialSelection: [GFElement], to finalSelection: [GFElement])
    
    /// Called when the selected element(s) was modified in any way. Ex: Translated, rotated, scaled.
    @objc optional func selectionStateDidChange(_ selection: GFSelection)
    
    
}
