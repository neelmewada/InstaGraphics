//
//  GFElement.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 05/05/21.
//

import UIKit

public class GFElement: GFView {
    // MARK: - Lifecycle
    
    public init(canvas: GFCanvas, id: String? = nil) {
        self.canvas = canvas
        self.id = (id == nil) ? UUID().uuidString : id!
        super.init(frame: .zero)
        
        // initialize the background once
        addSubview(background)
        background.fillSuperview()
        
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) { return nil }
    
    
    /// Creates and returns an actual element from the given serializedElement.
    /// - Parameters:
    ///   - serializedElement: The serialized element used to create the element.
    ///   - canvas: The canvas reference.
    public static func create(from serializedElement: GFCodableElement, canvas: GFCanvas) -> GFElement? {
        switch serializedElement.elementType {
        case .text:
            return GFTextElement(from: serializedElement, canvas: canvas)
        case .image:
            return GFImageElement(from: serializedElement, canvas: canvas)
        default:
            return nil
        }
    }
    
    // MARK: - Properties
    
    /// Unique Identifier for this GFElement. DON'T set it manually.
    public let id: String
    
    public weak var parentElement: GFElement? = nil
    
    public weak var canvas: GFCanvas!
    
    public internal(set) var isEditing = false
    
    internal weak var internalDelegate: GFElementDelegate? = nil
    
    public weak var delegate: GFElementDelegate? = nil
    
    /// The background of this GFElement
    public private(set) lazy var background = GFBackground(self)
    
    public private(set) var isSelected = false
    
    // MARK: - Computed Properties
    
    public final var isRemoved: Bool {
        return superview == nil
    }
    
    public var type: GFElementType {
        return .none // use none for canvas' background element
    }
    
    public var resizeMode: GFResizeMode {
        return .fixed
    }
    
    /// The serialized version of this element.
    public var serializedValue: GFCodableElement {
        return .create(from: self)
    }
    
    // MARK: - Methods
    
    /// Configure `this` element from a serialized element (GFCodableElement). Override this method in an element to implement configuration.
    /// - Parameter serializedElement: The serialized element data used to configure `this` element.
    /// - Returns: Returns true if sucessful, else false.
    @discardableResult public func configure(from serializedElement: GFCodableElement) -> Bool {
        return false
    }
    
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
    
    /// Creates and returns a duplicate of `this` element, if possible. Returns nil on failure.
    public func createDuplicate() -> GFElement? {
        return nil
    }
    
    /// Enable or disable editing mode for this element. Use it to implement text editing, etc.
    func setEditing(_ set: Bool) {
        let oldValue = isEditing
        isEditing = set
        
        if oldValue != set { // Check if value is changed
            internalDelegate?.element?(self, editingModeDidChange: set)
            delegate?.element?(self, editingModeDidChange: set)
        }
    }
    
    override func prepareForRender() {
        super.prepareForRender()
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

// MARK: - GFElementDelegate

@objc public protocol GFElementDelegate: AnyObject {
    
    @objc optional func element(_ element: GFElement, editingModeDidChange editMode: Bool)
    
}


