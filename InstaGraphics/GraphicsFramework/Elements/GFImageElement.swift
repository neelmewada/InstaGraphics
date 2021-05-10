//
//  GFImageElement.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 05/05/21.
//

import UIKit

class GFImageElement: GFElement {
    // MARK: - Lifecycle
    
    override init(canvas: GFCanvas) {
        super.init(canvas: canvas)
        configureElement()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    // MARK: - Properties
    
    override var type: GFElementType {
        return .image
    }
    
    // MARK: - Configuration
    
    private func configureElement() {
        
    }
    
    func configure() {
        
    }
    
    // MARK: - Methods
    
    override func layoutInitialize() {
        super.layoutInitialize()
        
    }
    
    override func layoutUpdate() {
        super.layoutUpdate()
        
    }
    
    override func prepareForRender() {
        super.prepareForRender()
    }
}
