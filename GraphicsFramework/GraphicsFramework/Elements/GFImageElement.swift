//
//  GFImageElement.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 05/05/21.
//

import UIKit

public class GFImageElement: GFElement {
    // MARK: - Lifecycle
    
    override init(canvas: GFCanvas) {
        super.init(canvas: canvas)
        configureElement()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    // MARK: - Properties
    
    public override var type: GFElementType {
        return .image
    }
    
    public override var resizeMode: GFResizeMode {
        return .maintainAspectRatio
    }
    
    // MARK: - Configuration
    
    private func configureElement() {
        
    }
    
    public func configure(withImage image: GFImageInfo, size: CGSize, contentMode: ContentMode) {
        guard let canvas = canvas else { return }
        
        let width = size.width * canvas.resolutionFactor.width
        let height = size.height * canvas.resolutionFactor.height
        self.frame.size = CGSize(width: width, height: height)
        print("Configuring Image element background: \(image.mode)")
        
        switch image.mode {
        case .local:
            background.configureImage(fromLocalUrls: image.urls, contentMode: contentMode)
        case .remote:
            background.configureImage(fromRemoteUrls: image.urls, contentMode: contentMode)
        default:
            break
        }
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
