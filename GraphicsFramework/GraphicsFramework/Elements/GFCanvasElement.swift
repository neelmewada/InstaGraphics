//
//  GFCanvasElement.swift
//  GraphicsFramework
//
//  Created by Neel Mewada on 29/05/21.
//

import UIKit

public class GFCanvasElement: GFElement {
    // MARK: - Lifecycle
    
    override public init(canvas: GFCanvas, id: String? = nil) {
        super.init(canvas: canvas, id: id)
        configureElement()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    // MARK: - Properties
    
    public override var type: GFElementType {
        return .canvas
    }
    
    public override var resizeMode: GFResizeMode {
        return .fixed
    }
    
    // MARK: - Configuration
    
    private func configureElement() {
        
    }
}
