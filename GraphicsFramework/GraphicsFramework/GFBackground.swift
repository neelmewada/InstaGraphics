//
//  GFBackgroundElement.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 05/05/21.
//

import UIKit
import SDWebImage

public class GFBackground: GFView {
    // MARK: - Lifecycle
    
    init(_ owner: GFView) {
        self.owner = owner
        super.init(frame: .zero)
        self.clipsToBounds = true
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
    
    public func configure(from info: GFBackgroundInfo) {
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
    
    public func configureColor(_ color: UIColor) {
        self.type = .color
        self.color = color
    }
    
    public func configureGradient(_ gradient: GFGradient) {
        self.type = .gradient
        self.gradient = gradient
    }
    
    public func configureImage(fromAsset named: String, contentMode: ContentMode = .scaleAspectFill) {
        self.type = .image
        self.image = .create(withMode: .asset, urls: [GFImageUrl(url: named, imageSize: .zero)])
        imageView?.contentMode = contentMode
        self.contentMode = contentMode
    }
    
    public func configureImage(fromLocalUrls urls: [GFImageUrl], contentMode: ContentMode = .scaleAspectFill) {
        self.type = .image
        self.image = .create(withMode: .local, urls: urls)
        imageView?.contentMode = contentMode
        self.contentMode = contentMode
    }
    
    public func configureImage(fromRemoteUrls urls: [GFImageUrl], contentMode: ContentMode = .scaleAspectFill) {
        self.type = .image
        self.image = .create(withMode: .remote, urls: urls)
        imageView?.contentMode = contentMode
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
        
        layoutIfNeeded()
        
        imageView!.contentMode = self.contentMode
        
        var imageUrl = image.urls.last!
        if image.urls.count > 4 {
            let count = image.urls.count
            imageUrl = image.urls[count - 2]
        }
        
        switch image.mode {
        case .asset:
            imageView!.image = UIImage(named: imageUrl.url)
        case .local:
            imageView!.image = UIImage(contentsOfFile: imageUrl.url)
        case .remote:
            imageView!.sd_setImage(with: URL(string: imageUrl.url))
            print("Setting remote image to: \(imageUrl.url) ; \(frame.size) ; \(originalFrame.size)")
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


