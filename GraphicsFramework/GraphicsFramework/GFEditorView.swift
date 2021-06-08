//
//  GFCanvasView.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 04/05/21.
//

import UIKit

/// The base editor view that is to be embedded in another view.
public class GFEditorView: UIView, GFSelectionDelegate {
    // MARK: - Lifecycle
    
    public init(document: GFDocument) {
        self.document = document
        super.init(frame: .zero)
        configureCanvas()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    // MARK: - Properties
    
    public weak var delegate: GFEditorViewDelegate? = nil
    
    public private(set) lazy var canvas = GFCanvas(editor: self, document: self.document)
    
    public private(set) var document: GFDocument
    
    public private(set) lazy var selection = GFSelection(editor: self)
    
    public private(set) lazy var operationManager = GFOperationManager(self)
    
    public private(set) lazy var actionManager = GFActionManager(self)
    
    public var zoomFactor: CGFloat {
        canvas.frame.width / document.resolution.width
    }
    
    public var resolutionFactor: CGSize {
        canvas.resolutionFactor
    }
    
    private weak var panTarget: UIView? = nil
    
    // MARK: - Configuration
    
    /// Called only once on init. Use it only to configure the UI. Ex: Adding subviews, constraints, gestures, etc.
    private func configureCanvas() {
        backgroundColor = .black
        self.clipsToBounds = false
        
        addSubview(canvas)
        addSubview(selection)
        selection.fillSuperview()
        
        selection.delegates.append(Weak(self))
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        pinchGesture.delegate = self
        addGestureRecognizer(pinchGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGesture.delegate = self
        addGestureRecognizer(panGesture)
        
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(_:)))
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.delegate = self
        addGestureRecognizer(singleTapGesture)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.delegate = self
        addGestureRecognizer(doubleTapGesture)
        
        singleTapGesture.require(toFail: doubleTapGesture)
        singleTapGesture.require(toFail: panGesture)
    }
    
    /// Use this function to configure or re-configure the editor. Call this method ONLY after viewDidAppear is called on the editing view controller
    public func configure() {
        canvas.configure(size: document.resolution, actualScaledWidth: GFUtils.orientationWidth * GFConstants.minCanvasWidthToScreenRatio)
        canvas.center = center
        canvas.canvasElement.background.configureImage(fromAsset: "test-image-2")
        layoutInitialize()
    }
    
    // MARK: - Actions
    
    internal func canvasDidChange() {
        delegate?.editorViewDidChange?(self)
    }
    
    @objc private func handlePan(_ recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began {
            let locationInSelection = recognizer.location(in: selection)
            if let selectionHitView = selection.hitTest(locationInSelection, with: nil) {
                if selectionHitView == selection {
                    panTarget = canvas
                    return
                }
                if selectionHitView is GFSelectionIndicator {
                    panTarget = selectionHitView as! GFSelectionIndicator
                }
                if selectionHitView is GFSelectionAnchor {
                    panTarget = selectionHitView as! GFSelectionAnchor
                }
            }
        }// else if recognizer.state == .ended || recognizer.state == .cancelled {
           // panTarget = nil
            //return
        //}
        
        if panTarget == nil {
            panTarget = canvas
        }
        
        guard var panTarget = panTarget else { return }
        
        if panTarget is GFSelectionIndicator {
            if selection.handlePan(recognizer, target: (panTarget as! GFSelectionIndicator)) {
                return
            } else {
                panTarget = canvas
            }
        } else if panTarget is GFSelectionAnchor {
            if selection.handlePan(recognizer, target: (panTarget as! GFSelectionAnchor)) {
                return
            } else {
                panTarget = canvas
            }
        }
                
        if recognizer.state == .began || recognizer.state == .changed {
            let translation = recognizer.translation(in: self)
            panTarget.center = CGPoint(x: panTarget.center.x + translation.x, y: panTarget.center.y + translation.y)
            layoutUpdate()
            recognizer.setTranslation(CGPoint.zero, in: self)
        }
        
        if recognizer.state == .ended {
            self.panTarget = nil
        }
    }
    
    @objc private func handlePinch(_ recognizer: UIPinchGestureRecognizer) {
        if recognizer.state == .changed {
            selection.setSelectionVisible(false)
            let center = canvas.center
            canvas.scaleBy(recognizer.scale)
            canvas.center = center
            layoutUpdate()
            recognizer.scale = 1
        } else if recognizer.state == .cancelled || recognizer.state == .ended {
            let minCanvasWidth = GFUtils.orientationWidth * GFConstants.minCanvasWidthToScreenRatio
            if canvas.canvasSize.width < minCanvasWidth {
                UIView.animate(withDuration: 0.4) {
                    self.canvas.setActualWidth(minCanvasWidth)
                    self.canvas.center = self.center
                    self.layoutUpdate()
                } completion: { _ in
                    self.selection.setSelectionVisible(true)
                }
            } else {
                selection.setSelectionVisible(true)
            }
        }
    }
    
    private var textAdded: Bool = false // testing-only
    
    @objc private func handleSingleTap(_ recognizer: UITapGestureRecognizer) {
        let locationInSelection = recognizer.location(in: selection)
        if let selectionHitView = selection.hitTest(locationInSelection, with: nil) { // Hit selection or it's subview
            // if we hit something important in Selection view, then return
            if selectionHitView != selection &&
                selection.selection?.type != GFElementType.canvas {
                return
            }
        }
        
        let isCanvasSelected = selection.selectedElements.compactMap{ $0.value }.contains(where: { $0.type == .canvas })
        
        let locationInCanvas = recognizer.location(in: canvas)
        if let hitView = canvas.hitTest(locationInCanvas, with: nil) { // Hit canvas or it's subview
            
            // For testing only... add a text element
            if hitView == canvas && !textAdded {
                let textElement = GFTextElement(canvas: canvas)
                canvas.addElement(textElement, atCenter: locationInCanvas)
                let textConfig = GFTextElement.Configuration(text: "Enter text...")
                textElement.configure(textConfig)
                textAdded = true
                return
            }
            
            // Return if user single tapped on an already selected element
            if hitView is GFElement && selection.isElementSelected(hitView as! GFElement) {
                return
            }
            
            if hitView is GFElement {
                selection.selectElement(hitView as! GFElement)
            } else if !(hitView is UITextView) && !isCanvasSelected {
                selection.deselectAllElements()
            }
            
            if hitView is GFView {
                (hitView as? GFView)?.viewSingleTapped()
            }
            
        } else { // No hits
            selection.deselectAllElements()
            
            // For testing only...
            //setDocumentResolution(CGSize(width: document.resolution.width * 1.5, height: document.resolution.height * 1.5))
        }
    }
    
    @objc private func handleDoubleTap(_ recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: canvas)
        if let hitView = canvas.hitTest(location, with: nil) {
            if let element = hitView as? GFElement {
                
                if selection.isActive && !selection.isElementSelected(element) {
                    selection.deselectAllElements()
                    return
                }
                
                if !element.isSelected {
                    selection.selectElement(element)
                }
                element.viewDoubleTapped()
                element.setEditing(true)
                                
            } else if let view = hitView as? GFView {
                
                if selection.isActive {
                    selection.deselectAllElements()
                }
                
                view.viewDoubleTapped()
            }
        }
    }
    
    // MARK: - Methods
    
    /// Calls layout setup on canvas
    public func layoutInitialize() {
        canvas.layoutInitialize()
        selection.layoutInitialize()
    }
    
    /// Calls layout update on canvas
    public func layoutUpdate() {
        canvas.layoutUpdate()
        selection.layoutUpdate()
    }
    
    public func setDocumentResolution(_ newResolution: CGSize) {
        let oldResolution = document.resolution
        document.resolution = newResolution
        canvas.documentResolutionChanged(from: oldResolution, to: newResolution)
        selection.documentResolutionChanged(from: oldResolution, to: newResolution)
        layoutUpdate()
    }
    
    /// Testing Function ONLY
    public func capture() {
        canvas.setActualWidth(document.resolution.width)
        canvas.center = center
        
        UIGraphicsBeginImageContextWithOptions(canvas.frame.size, false, 1.0)
        canvas.drawHierarchy(in: CGRect(x: 0, y: 0, width: canvas.frame.width, height: canvas.frame.height), afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //let ac = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
        //AppUtils.topViewController?.present(ac, animated: true, completion: nil)
    }
    
}


// MARK: - UIGestureRecognizerDelegate

extension GFEditorView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - Internal Methods

extension GFEditorView {
    
    internal func addImageElement(withImage image: GFCodableImage, recordOperation: Bool) {
        let imageElement = GFImageElement(canvas: canvas)
        
        var imageSize = image.urls.last!.imageSize
        let imageAspectRatio = imageSize.width / imageSize.height
        imageSize.width = canvas.originalFrame.width * 0.5
        imageSize.height = imageSize.width / imageAspectRatio
        
        print("Adding image: \(imageSize) ; \(canvas.originalFrame.size)")
        imageElement.configure(withImage: image, size: imageSize, contentMode: .scaleAspectFill)
        
        addElement(imageElement)
    }
    
    internal func addElement(_ element: GFElement, recordOperation: Bool, autoSelect: Bool = true) {
        if recordOperation {
            let initialState = [GFCodableElement]()
            let finalState = [element.serializedValue]
            operationManager.recordOperation(initialState, finalState)
        }
        canvas.addElement(element, atOrigin: element.originalFrame.origin, withSize: element.size, autoSelect: autoSelect)
    }
    
    internal func addElement(from serializedElement: GFCodableElement, recordOperation: Bool, autoSelect: Bool = true) {
        if recordOperation {
            let initialState = [GFCodableElement]()
            let finalState = [serializedElement]
            operationManager.recordOperation(initialState, finalState)
        }
        canvas.addElement(from: serializedElement, autoSelect: autoSelect)
    }
    
    internal func removeElement(_ element: GFElement, recordOperation: Bool) {
        if recordOperation {
            let initialState = [element.serializedValue]
            let finalState = [GFCodableElement]()
            operationManager.recordOperation(initialState, finalState)
        }
        selection.deselectElement(element)
        canvas.removeElement(element)
    }
}

// MARK: - Public API

extension GFEditorView {
    
    open func addImageElement(withImage image: GFCodableImage) {
        let imageElement = GFImageElement(canvas: canvas)
        
        var imageSize = image.urls.last!.imageSize
        let imageAspectRatio = imageSize.width / imageSize.height
        imageSize.width = canvas.originalFrame.width * 0.5
        imageSize.height = imageSize.width / imageAspectRatio
        
        print("Adding image: \(imageSize) ; \(canvas.originalFrame.size)")
        imageElement.configure(withImage: image, size: imageSize, contentMode: .scaleAspectFill)
        
        addElement(imageElement)
    }
    
    /// Adds element and record it to undo/redo stack.
    open func addElement(_ element: GFElement, autoSelect: Bool = true) {
        addElement(element, recordOperation: true, autoSelect: autoSelect)
    }
    
    open func addElement(from serializedElement: GFCodableElement, autoSelect: Bool = true) {
        addElement(from: serializedElement, recordOperation: true, autoSelect: autoSelect)
    }
    
    open func removeElement(_ element: GFElement) {
        removeElement(element, recordOperation: true)
    }
    
    open func removeElement(withId id: String) {
        if let element = findElement(withId: id) {
            removeElement(element)
        }
    }
    
    open func findElement(withId id: String) -> GFElement? {
        return canvas.findElement(withId: id)
    }
    
    open func performActionOnSelection(_ action: GFAction) {
        actionManager.performAction(action, on: selection.selectedElements.compactMap{ $0.value })
    }
    
    open func performAction(_ action: GFAction, on elements: [GFElement] = []) {
        actionManager.performAction(action, on: elements)
    }
}

// MARK: - GFEditorViewDelegate

@objc public protocol GFEditorViewDelegate {
    
    /// Called when a change is made in the editor view. Ex: selection change, element moved, element added, etc.
    @objc optional func editorViewDidChange(_ editorView: GFEditorView)
    
}
