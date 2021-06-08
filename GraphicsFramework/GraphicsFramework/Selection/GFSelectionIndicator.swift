//
//  GFSelectionIndicator.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 07/05/21.
//

import UIKit

class GFSelectionIndicator: GFView {
    // MARK: - Lifecycle
    
    init(_ element: GFElement, parent: GFSelection, canvas: GFCanvas) {
        self.parent = parent
        self.canvas = canvas
        self.element = element
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    // MARK: - Properties
    
    private let borderLayer = CAShapeLayer()
    
    public private(set) weak var parent: GFSelection? = nil
    
    public private(set) weak var element: GFElement?
    
    public private(set) weak var canvas: GFCanvas?
    
    public private(set) var anchorPoints = [GFSelectionAnchor]()
    
    // MARK: - Configuration
    
    /// Called only once on init.
    private func configureView() {
        self.clipsToBounds = false
        backgroundColor = .clear
        self.isUserInteractionEnabled = true
        
        layer.addSublayer(borderLayer)
    }
    
    // MARK: - Methods
    
    internal func removeAllAnchors() {
        anchorPoints.forEach { anchorPoint in
            anchorPoint.removeFromSuperview()
        }
        anchorPoints.removeAll()
    }
    
    internal func setAnchorsVisible(_ visible: Bool) {
        anchorPoints.forEach { anchorPoint in
            anchorPoint.isHidden = !visible
        }
    }
    
    private func addAnchorPoint(ofType type: GFSelectionAnchorType, at position: GFSelectionAnchorPosition) {
        guard let parent = parent else { return }
        
        let anchorPoint = GFSelectionAnchor(self, parent: parent, type: type, position: position)
        anchorPoints.append(anchorPoint)
    }
    
    // MARK: - Overrides
    
    override func layoutInitialize() {
        super.layoutInitialize()
        guard let canvas = canvas else { return }
        guard let element = element else { return }
        
        let newFrame = canvas.convert(element.originalFrame, to: parent)
        self.originalFrame = newFrame
        self.rotation = element.rotation
        
        borderLayer.lineWidth = 2
        borderLayer.strokeColor = GFConstants.selectionColor.cgColor
        borderLayer.fillColor = nil
        borderLayer.frame = self.bounds
        borderLayer.path = UIBezierPath(rect: borderLayer.bounds).cgPath
        
        if element.type != .canvas { // 'canvas' represents GFCanvasElement (background)
            addAnchorPoint(ofType: .circle, at: .topLeft)
            addAnchorPoint(ofType: .circle, at: .topRight)
            addAnchorPoint(ofType: .circle, at: .bottomLeft)
            addAnchorPoint(ofType: .circle, at: .bottomRight)
            
            addAnchorPoint(ofType: .rotator, at: .stack(0, 1))
        }
        
        anchorPoints.forEach { anchor in
            anchor.layoutInitialize()
        }
    }
    
    override func layoutUpdate() {
        super.layoutUpdate()
        guard let canvas = canvas else { return }
        guard let element = element else {
            parent?.destroyIndicator(self)
            if parent == nil {
                removeFromSuperview()
            }
            return
        }
        
        let newFrame = canvas.convert(element.originalFrame, to: parent)
        self.originalFrame = newFrame
        self.rotation = element.rotation
        
        borderLayer.frame = self.bounds
        borderLayer.path = UIBezierPath(rect: self.bounds).cgPath
        
        if let textElement = (element as? GFTextElement) {
            if textElement.isEditing {
                borderLayer.lineDashPattern = [6, 3]
            } else {
                borderLayer.lineDashPattern = nil
            }
        }
        
        anchorPoints.forEach { anchor in
            anchor.layoutUpdate()
        }
    }
}
