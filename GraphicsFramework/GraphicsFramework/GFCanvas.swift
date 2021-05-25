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
        self.baseResolution = document.resolution
        super.init(frame: .zero)
        self.editorView = editor
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
    
    public private(set) lazy var background = GFBackground(self)
    
    private var elements: [GFElement] = []
    
    private weak var editorView: GFEditorView? = nil
    
    public weak var editor: GFEditorView? {
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
        
        addSubview(background)
    }
    
    /// You need to call this function to configure the canvas.
    func configure(size: CGSize, actualScaledWidth: CGFloat) {
        canvasSize = size
        setActualWidth(actualScaledWidth)
    }
    
    // MARK: - Methods
    
    override func layoutInitialize() {
        super.layoutInitialize()
        let zoomFactor = editorView!.zoomFactor
        background.layoutInitialize()
        background.frame = CGRect(x: 0, y: 0, width: frame.size.width / zoomFactor, height: frame.size.height / zoomFactor)
        
        elements.forEach { el in
            el.layoutInitialize()
        }
    }
    
    /// Called when layout/bounds of a parent view or this view changed.
    override func layoutUpdate() {
        super.layoutUpdate()
        background.layoutUpdate()
        
        elements.forEach { el in
            el.layoutUpdate()
        }
    }
    
    override func documentResolutionChanged(from oldRes: CGSize, to newRes: CGSize) {
        super.documentResolutionChanged(from: oldRes, to: newRes)
        setScaleToMatch(finalActualSize: newRes)
        
        background.documentResolutionChanged(from: oldRes, to: newRes)
        
        elements.forEach { el in
            el.documentResolutionChanged(from: oldRes, to: newRes)
        }
    }
    
    override func prepareForRender() {
        super.prepareForRender()
        background.prepareForRender()
        
        elements.forEach { el in
            el.prepareForRender()
        }
    }
    
    override func unprepareAfterRender() {
        super.unprepareAfterRender()
        background.unprepareAfterRender()
        
        elements.forEach { el in
            el.unprepareAfterRender()
        }
    }
    
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
    
    /// Add element to the canvas.
    func addElement(_ element: GFElement, at position: CGPoint) {
        guard let _ = editorView else { return }
        
        addSubview(element)
        element.layoutInitialize()
        element.center = position
    }
    
    /// Remove element from the canvas.
    func removeElement(_ element: GFElement) {
        element.removeFromSuperview()
    }
}
