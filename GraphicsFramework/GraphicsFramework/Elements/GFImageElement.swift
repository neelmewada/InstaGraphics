//
//  GFImageElement.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 05/05/21.
//

import UIKit

public class GFImageElement: GFElement {
    // MARK: - Lifecycle
    
    override init(canvas: GFCanvas, id: String? = nil) {
        super.init(canvas: canvas, id: id)
        configureElement()
    }
    
    internal init?(from serializedElement: GFCodableElement, canvas: GFCanvas) {
        super.init(canvas: canvas, id: serializedElement.id)
        if !configure(from: serializedElement) {
            return nil
        }
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
    
    @discardableResult public override func configure(from serializedElement: GFCodableElement) -> Bool {
        if serializedElement.elementType != .image {
            return false
        }
        
        background.configure(from: serializedElement.background)
        
        self.position = serializedElement.position
        self.size = serializedElement.size
        self.rotation = serializedElement.rotation
        
        let config = Configuration(image: serializedElement.background.image, size: size, contentMode: ContentMode.scaleAspectFill.rawValue)
        self.configure(config)
        
        return true
    }
    
    public func configure(_ config: Configuration) {
        self.configure(withImage: config.image, size: config.size, contentMode: ContentMode(rawValue: config.contentMode) ?? .scaleAspectFill)
    }
    
    public func configure(withImage image: GFCodableImage, size: CGSize, contentMode: ContentMode) {
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
