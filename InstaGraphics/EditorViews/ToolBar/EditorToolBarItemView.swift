//
//  EditorToolBarItem.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 29/05/21.
//

import UIKit
import GraphicsFramework

class EditorToolBarItemView: UIView {
    // MARK: - Lifecycle
    
    init(toolBar: EditorToolBar) {
        self.toolBar = toolBar
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    // MARK: - Private Properties
    
    private weak var toolBar: EditorToolBar!
    
    private var item: EditorToolBarItem? = nil
    
    // MARK: - Configuration
    
    private func configureView() {
        setDimensions(height: 50, width: 50)
        
        addSubview(selectorBackground)
        selectorBackground.fillSuperview()
        
        addSubview(imageView)
        imageView.centerInSuperview()
        imageView.setDimensions(height: 20, width: 20)
        
        self.isUserInteractionEnabled = true
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        addGestureRecognizer(longPressGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGesture)
        
        tapGesture.require(toFail: longPressGesture)
    }
    
    public func configure(_ item: EditorToolBarItem) {
        self.item = item
        imageView.image = item.icon?.withTintColor(item.tintColor, renderingMode: .alwaysOriginal)
    }
    
    // MARK: - Actions
    
    @objc private func handleLongPress(_ longPressGesture: UILongPressGestureRecognizer) {
        
        if longPressGesture.state == .began { // START
            print("Long Pressed")
            
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            
            UIView.animate(withDuration: 0.1) {
                self.selectorBackground.alpha = 1
            }
            
        } else if longPressGesture.state == .changed { // Finger MOVED
            
        } else if longPressGesture.state == .ended { // END
            
            UIView.animate(withDuration: 0.1) {
                self.selectorBackground.alpha = 0
            }
        }
    }
    
    @objc private func handleTap(_ tapGesture: UITapGestureRecognizer) {
        guard let item = item else { return }
        toolBar.performAction(item.action)
    }
    
    // MARK: - Views
    
    private let selectorBackground: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 18
        view.backgroundColor = .init(white: 1, alpha: 0.25)
        view.clipsToBounds = true
        view.alpha = 0
        view.isUserInteractionEnabled = false
        return view
    }()
    
    public let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = false
        return view
    }()
}

