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
    
    private(set) var item: EditorToolBarItem? = nil
    
    private var longPressGesture: UILongPressGestureRecognizer!
    private var tapGesture: UITapGestureRecognizer!
    
    // MARK: - Configuration
    
    private func configureView() {
        setDimensions(height: 50, width: 50)
        
        addSubview(selectorBackground)
        selectorBackground.fillSuperview()
        
        addSubview(imageView)
        imageView.centerInSuperview()
        imageView.setDimensions(height: 20, width: 20)
        
        self.isUserInteractionEnabled = true
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        addGestureRecognizer(longPressGesture)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGesture)
        
        tapGesture.require(toFail: longPressGesture)
    }
    
    public func configure(_ item: EditorToolBarItem) {
        self.item = item
        imageView.image = item.icon?.withTintColor(item.tintColor, renderingMode: .alwaysOriginal)
    }
    
    // MARK: - Actions
    
    func discardGestures() {
        longPressGesture.state = .cancelled
        tapGesture.state = .cancelled
        selectorBackground.alpha = 0
    }
    
    @objc private func handleLongPress(_ longPressGesture: UILongPressGestureRecognizer) {
        
        if longPressGesture.state == .began { // START
            
            //if !toolBar.showPopup(for: self) { // cancel gesture if we can't show the popup
            if !toolBar.processLongPress(on: self) { // cancel gesture if long press is invalid
                longPressGesture.state = .cancelled
                return
            }
            
            UISelectionFeedbackGenerator().selectionChanged()
            
            UIView.animate(withDuration: 0.1) {
                self.selectorBackground.alpha = 1
            }
            
        } else if longPressGesture.state == .changed { // Finger MOVED
            
        } else if longPressGesture.state == .ended { // END
            
            UIView.animate(withDuration: 0.1) {
                self.selectorBackground.alpha = 0
            }
            
            toolBar.hidePopup()
        }
    }
    
    @objc private func handleTap(_ tapGesture: UITapGestureRecognizer) {
        toolBar.processTap(on: self)
    }
    
    // MARK: - Methods
    
    private func showPopup() {
        
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

