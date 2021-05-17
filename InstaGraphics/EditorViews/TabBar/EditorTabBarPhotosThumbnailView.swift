//
//  EditorTabBarPhotosThumbnailView.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 17/05/21.
//

import UIKit
import SDWebImage

class EditorTabBarPhotosThumbnailView: UICollectionViewCell {
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    // MARK: - Properties
    
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    public private(set) var image: GFImageInfo? = nil
    
    // MARK: - Configuration
    
    private func configureView() {
        backgroundColor = .clear
        
        addSubview(imageView)
        imageView.centerInParent()
        imageView.setDimensions(height: 118, width: 118)
    }
    
    public func configureData(_ image: GFImageInfo) {
        self.image = image
        if !image.thumbnailUrl.url.isEmpty {
            imageView.sd_setImage(with: URL(string: image.thumbnailUrl.url), placeholderImage: imageView.image)
        } else {
            imageView.sd_setImage(with: URL(string: image.urls[0].url), placeholderImage: imageView.image)
        }
    }
}
