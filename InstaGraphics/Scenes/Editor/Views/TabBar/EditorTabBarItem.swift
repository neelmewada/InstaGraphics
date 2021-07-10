//
//  EditorTabBarItem.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 06/05/21.
//

import UIKit

class EditorTabBarItem: UIView {
    // MARK: - Lifecycle
    
    init(imageName: String, text: String, contentView: EditorPopupContentView? = nil, action: EditorTabBarAction? = nil) {
        self.imageName = imageName
        self.text = text
        self.itemView = contentView
        self.action = action
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    // MARK: - Properties
    
    private var tapCallback: ((EditorTabBarItem) -> ())? = nil
    
    private var action: EditorTabBarAction? = nil
    
    public let imageName: String
    public let text: String
    public let itemView: EditorPopupContentView?
    
    public lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: imageName)
        view.contentMode = .scaleAspectFit
        view.setDimensions(height: 28, width: 28)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Roboto-Regular", size: 10)
        label.text = text
        return label
    }()
    
    // MARK: - Configuration
    
    private func configureView() {
        setWidth(width: 28)
        
        addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 28)
        
        addSubview(titleLabel)
        titleLabel.anchor(top: imageView.bottomAnchor, spacingTop: 18)
        titleLabel.centerX(inView: self)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonTapped)))
    }
    
    public func setTapHandler(_ handler: @escaping (EditorTabBarItem) -> ()) {
        self.tapCallback = handler
    }
    
    // MARK: - Actions
    
    @objc private func buttonTapped() {
        tapCallback?(self)
    }
}
