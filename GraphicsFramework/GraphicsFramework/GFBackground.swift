//
//  GFBackgroundElement.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 05/05/21.
//

import UIKit

public class GFBackground: GFView {
    // MARK: - Lifecycle
    
    init(_ owner: GFView) {
        self.owner = owner
        super.init(frame: .zero)
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) { return nil }
    
    // MARK: - Properties
    
    public private(set) weak var owner: GFView?
    
    private var gradientLayer: CAGradientLayer? = nil
    private var imageView: UIImageView? = nil
    
    public private(set) var type: GFBackgroundType = .clear
    public var backgroundContentMode: ContentMode = .scaleAspectFill {
        didSet {
            updateContentMode()
        }
    }
    
    public private(set) var color: UIColor {
        get {
            if type != .color {
                return .clear
            }
            return backgroundColor ?? .clear
        }
        set {
            if type == .color {
                backgroundColor = newValue
            } else {
                backgroundColor = .clear
            }
        }
    }
    
    public private(set) var gradient: GFGradient = .empty {
        didSet {
            if gradient.isEmpty {
                gradientLayer?.removeFromSuperlayer()
                gradientLayer = nil
                return
            }
            if type != .gradient {
                return
            }
            if gradientLayer == nil {
                gradientLayer = CAGradientLayer()
                gradientLayer!.frame = self.layer.frame
                self.layer.addSublayer(gradientLayer!)
            }
            gradientLayer!.colors = gradient.cgColors
            gradientLayer!.locations = gradient.numbers
        }
    }
    
    public private(set) var image: GFImageInfo = .empty {
        didSet {
            updateImageView()
        }
    }
    
    // MARK: - Configuration
    
    func configure(from info: GFBackgroundInfo) {
        self.type = info.type
        switch self.type {
        case .color:
            color = info.color.uiColor
        case .gradient:
            gradient = info.gradient
        case .image:
            image = info.image
        case .clear:
            image = .empty
            color = .clear
            gradient = .empty
            break
        }
    }
    
    func configureColor(_ color: UIColor) {
        self.type = .color
        self.color = color
    }
    
    func configureGradient(_ gradient: GFGradient) {
        self.type = .gradient
        self.gradient = gradient
    }
    
    func configureImage(_ image: GFImageInfo) {
        self.type = .image
        self.image = image
    }
    
    func configureImage(fromAsset named: String, contentMode: ContentMode = .scaleAspectFill) {
        self.type = .image
        self.image = .create(withMode: .asset, urls: [GFImageUrl(url: named, imageSize: .zero)])
        self.contentMode = contentMode
    }
    
    func configureImage(fromLocalUrls urls: [GFImageUrl], contentMode: ContentMode = .scaleAspectFill) {
        self.type = .image
        self.image = .create(withMode: .local, urls: urls)
        self.contentMode = contentMode
    }
    
    func configureImage(fromRemoteUrls urls: [GFImageUrl], contentMode: ContentMode = .scaleAspectFill) {
        self.type = .image
        self.image = .create(withMode: .remote, urls: urls)
        self.contentMode = contentMode
    }
    
    // MARK: - Methods
    
    private func removeGradient() {
        gradientLayer?.removeFromSuperlayer()
        self.gradientLayer = nil
    }
    
    private func removeColor() {
        self.color = .clear
    }
    
    private func removeImage() {
        self.image = .empty
    }
    
    private func updateImageView() {
        if image.urls.count == 0 { // Reset to Clear color if no image is empty
            imageView?.removeFromSuperview()
            imageView = nil
            return
        }
        
        if imageView == nil {
            imageView = UIImageView()
            addSubview(imageView!)
            imageView!.fillSuperview()
        }
        
        imageView!.contentMode = self.contentMode
        
        switch image.mode {
        case .asset:
            imageView!.image = UIImage(named: image.urls.first!.url)
        case .local:
            break
        case .remote:
            break
        }
    }
    
    private func updateContentMode() {
        imageView?.contentMode = backgroundContentMode
    }
    
    // MARK: - Overrides
    
    override func layoutInitialize() {
        super.layoutInitialize()
    }
    
    override func layoutUpdate() {
        super.layoutUpdate()
    }
    
    override func prepareForRender() {
        super.prepareForRender()
    }
    
    override func unprepareAfterRender() {
        super.unprepareAfterRender()
    }
}


