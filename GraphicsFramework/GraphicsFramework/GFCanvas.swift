//
//  GFCanvas.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 04/05/21.
//

import UIKit

public class GFCanvas: GFView {
    // MARK: - Lifecycle
    
    init(editor: GFEditorView, document: GFDocument) {
        self.document = document
        self.editorView = editor
        self.baseResolution = document.resolution
        super.init(frame: .zero)
        configureCanvas()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    public override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        
        if subview is GFElement {
            elements.append(subview as! GFElement)
            // TODO: - modify the GFDocument
        }
    }
    
    public override func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)
        
        if subview is GFElement {
            let element = subview as! GFElement
            if let index = elements.firstIndex(of: element) {
                elements.remove(at: index)
            }
            // TODO: - modify the GFDocument
        }
    }
    
    // MARK: - Properties
    
    /// The underlying frame size. Ignores the scale.
    public var canvasSize: CGSize {
        get { frame.size }
        set { frame.size = newValue }
    }
    
    public var zoomFactor: CGFloat {
        return frame.width / document.resolution.width
    }
    
    /// The resolution of document when the canvas was first initialized.
    public private(set) var baseResolution: CGSize
    
    public private(set) var document: GFDocument
    
    public private(set) lazy var canvasElement = GFCanvasElement(canvas: self)
    
    private var elements: [GFElement] = []
    
    private weak var editorView: GFEditorView!
    
    public weak var editor: GFEditorView! {
        return editorView
    }
    
    public var resolutionFactor: CGSize {
        CGSize(width: document.resolution.width / baseResolution.width,
               height: document.resolution.height / baseResolution.height)
    }
    
    // MARK: - Configuration
    
    /// Called only once on init.
    private func configureCanvas() {
        self.translatesAutoresizingMaskIntoConstraints = true
        self.autoresizesSubviews = false
        self.clipsToBounds = true
        backgroundColor = .white
        
        addSubview(canvasElement)
    }
    
    /// You need to call this function to configure the canvas.
    func configure(size: CGSize, actualScaledWidth: CGFloat) {
        canvasSize = size
        setActualWidth(actualScaledWidth)
    }
    
    // MARK: - Overrides
    
    override func layoutInitialize() {
        super.layoutInitialize()
        let zoomFactor = editorView!.zoomFactor
        canvasElement.layoutInitialize()
        canvasElement.frame = CGRect(x: 0, y: 0, width: frame.size.width / zoomFactor, height: frame.size.height / zoomFactor)
        
        elements.forEach { el in
            el.layoutInitialize()
        }
    }
    
    /// Called when layout/bounds of a parent view or this view changed.
    override func layoutUpdate() {
        super.layoutUpdate()
        canvasElement.layoutUpdate()
        
        elements.forEach { el in
            el.layoutUpdate()
        }
    }
    
    override func documentResolutionChanged(from oldRes: CGSize, to newRes: CGSize) {
        super.documentResolutionChanged(from: oldRes, to: newRes)
        setScaleToMatch(finalActualSize: newRes)
        
        canvasElement.documentResolutionChanged(from: oldRes, to: newRes)
        
        elements.forEach { el in
            el.documentResolutionChanged(from: oldRes, to: newRes)
        }
    }
    
    override func prepareForRender() {
        super.prepareForRender()
        canvasElement.prepareForRender()
        
        elements.forEach { el in
            el.prepareForRender()
        }
    }
    
    override func unprepareAfterRender() {
        super.unprepareAfterRender()
        canvasElement.unprepareAfterRender()
        
        elements.forEach { el in
            el.unprepareAfterRender()
        }
    }
    
    // MARK: - Methods
    
    /// Scales the canvas' transform by the given scale.
    func scaleBy(_ scale: CGFloat) {
        transform = transform.scaledBy(x: scale, y: scale)
    }
    
    /// Scales the canvas' transform by the given x & y scales.
    func scaleBy(scaleX x: CGFloat, scaleY y: CGFloat) {
        transform = transform.scaledBy(x: x, y: y)
    }
    
    /// Scales the canvas to match the given actual size.
    func setScaleToMatch(finalActualSize size: CGSize) {
        let widthFactor = size.width / frame.width
        let heightFactor = size.height / frame.height
        scaleBy(scaleX: widthFactor, scaleY: heightFactor)
    }
    
    /// Scales the canvas to match given actual width.
    func setActualWidth(_ width: CGFloat) {
        let factor = width / frame.size.width
        scaleBy(factor)
    }
    
    /// Scales the canvas to match the given actual height.
    func setActualHeight(_ height: CGFloat) {
        let factor = height / frame.size.height
        scaleBy(factor)
    }
    
    // MARK: - Public API
    
    /// Add element to the canvas.
    public func addElement(_ element: GFElement, atCenter center: CGPoint, autoSelect: Bool = true) {
        addSubview(element)
        element.layoutInitialize()
        element.center = center
        editor.canvasDidChange()
        if autoSelect {
            editor.selection.selectElement(element)
        }
        print("Added element with id: \(element.id)")
    }
    
    public func addElement(_ element: GFElement, atOrigin origin: CGPoint, withSize size: CGSize? = nil, autoSelect: Bool = true) {
        addSubview(element)
        element.layoutInitialize()
        element.position = origin
        if let size = size {
            element.size = size
        }
        editor.canvasDidChange()
        if autoSelect {
            editor.selection.selectElement(element)
        }
        print("Added element with id: \(element.id)")
    }
    
    public func addElement(_ element: GFElement, autoSelect: Bool = true) {
        addSubview(element)
        element.layoutInitialize()
        editor.canvasDidChange()
        if autoSelect {
            editor.selection.selectElement(element)
        }
        print("Added element with id: \(element.id)")
    }
    
    @discardableResult public func addElement(from serializedElement: GFCodableElement, autoSelect: Bool = true) -> GFElement? {
        guard let element = GFElement.create(from: serializedElement, canvas: self) else {
            print("Error adding element from serialized element:\n \(serializedElement)")
            return nil
        }
        
        addElement(element, atOrigin: serializedElement.position, withSize: serializedElement.size, autoSelect: autoSelect)
        return element
    }
    
    /// Remove element from the canvas.
    public func removeElement(_ element: GFElement) {
        elements.removeAll(where: { $0 == element })
        element.removeFromSuperview()
        editor.canvasDidChange()
        editor.selection.deselectElement(element)
        print("Removed element with id: \(element.id)")
    }
    
    public func removeElement(withId id: String) {
        if let element = findElement(withId: id) {
            removeElement(element)
        }
    }
    
    public func findElement(withId id: String) -> GFElement? {
        if canvasElement.id == id {
            return canvasElement
        }
        
        if let index = elements.firstIndex(where: { $0.id == id }) {
            return elements[index]
        }
        return nil
    }
}
