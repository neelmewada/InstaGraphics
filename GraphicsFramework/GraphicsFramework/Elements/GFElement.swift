//
//  GFElement.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 05/05/21.
//

import UIKit

public class GFElement: GFView {
    // MARK: - Lifecycle
    
    init(canvas: GFCanvas) {
        self.canvas = canvas
        super.init(frame: .zero)
        // initialize the element once
        addSubview(background)
        background.fillSuperview()
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) { return nil }
    
    // MARK: - Properties
    
    public var parentElement: GFElement? = nil
    
    public weak var canvas: GFCanvas? = nil
    
    public internal(set) var isEditing = false
    
    /// The background of this GFElement
    public private(set) lazy var background = GFBackground(self)
    
    public private(set) var isSelected = false
    
    public var type: GFElementType {
        return .none
    }
    
    public var resizeMode: GFResizeMode {
        return .defaultMode
    }
    
    // MARK: - Methods
    
    override func layoutInitialize() {
        super.layoutInitialize()
        background.layoutInitialize()
    }
    
    override func layoutUpdate() {
        super.layoutUpdate()
        background.layoutUpdate()
    }
    
    override func documentResolutionChanged(from oldRes: CGSize, to newRes: CGSize) {
        super.documentResolutionChanged(from: oldRes, to: newRes)
        background.documentResolutionChanged(from: oldRes, to: newRes)
    }
    
    /// Enable or disable editing mode for this element. Use it to implement text editing, etc.
    func setEditing(_ set: Bool) {
        isEditing = set
    }
    
    override func prepareForRender() {
        super.prepareForRender()
    }
    
    func removeElement() {
        self.removeFromSuperview()
    }
    
    /// Called when this element is selected.
    func elementSelected() {
        isSelected = true
    }
    
    /// Called when the element is deselected.
    func elementDeselected() {
        isSelected = false
    }
}

