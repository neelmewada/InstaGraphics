//
//  GFCanvasView.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 04/05/21.
//

import UIKit
import GraphicsFramework

/// The base editor view that is to be embedded in another view.
public class GFEditorView: UIView, UIGestureRecognizerDelegate {
    // MARK: - Lifecycle
    
    public init(document: GFDocument) {
        self.document = document
        super.init(frame: .zero)
        configureCanvas()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    // MARK: - Properties
    
    public private(set) lazy var canvas = GFCanvas(editor: self, document: self.document)
    
    public private(set) var document: GFDocument
    
    public private(set) lazy var selection = GFSelection(editor: self)
    
    public var zoomFactor: CGFloat {
        canvas.frame.width / document.resolution.width
    }
    
    public var resolutionFactor: CGSize {
        canvas.resolutionFactor
    }
    
    private weak var panTarget: UIView? = nil
    
    // MARK: - Actions
    
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
        } else if recognizer.state == .ended || recognizer.state == .cancelled {
            panTarget = nil
            return
        }
        
        if panTarget == nil {
            panTarget = canvas
        }
        
        guard let panTarget = panTarget else { return }
        
        if panTarget is GFSelectionIndicator {
            let _ = selection.handlePan(recognizer, target: (panTarget as! GFSelectionIndicator))
            return
        } else if panTarget is GFSelectionAnchor {
            let _ = selection.handlePan(recognizer, target: (panTarget as! GFSelectionAnchor))
            return
        }
        
        if recognizer.state == .began || recognizer.state == .changed {
            let translation = recognizer.translation(in: self)
            panTarget.center = CGPoint(x: panTarget.center.x + translation.x, y: panTarget.center.y + translation.y)
            layoutUpdate()
            recognizer.setTranslation(CGPoint.zero, in: self)
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
            if selectionHitView != selection { // if we hit something important in Selection view, then return
                return
            }
        }
        
        let locationInCanvas = recognizer.location(in: canvas)
        if let hitView = canvas.hitTest(locationInCanvas, with: nil) { // Hit canvas or it's subview
            // For testing only...
            if hitView == canvas && !textAdded {
                let textElement = GFTextElement(canvas: canvas)
                canvas.addElement(textElement, at: locationInCanvas)
                let textConfig = GFTextElement.Configuration(initialText: "Enter text...")
                textElement.configure(textConfig)
                textAdded = true
                return
            }
            
            if hitView is GFElement {
                selection.selectElement(hitView as! GFElement)
            } else {
                selection.deselectAllElements()
            }
            if hitView is GFView {
                (hitView as? GFView)?.viewSingleTapped()
            }
        } else { // No hits
            // For testing only...
            setDocumentResolution(CGSize(width: document.resolution.width * 1.5, height: document.resolution.height * 1.5))
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
    
    public func capture() {
        canvas.setActualWidth(document.resolution.width)
        canvas.center = center
        
        UIGraphicsBeginImageContextWithOptions(canvas.frame.size, false, 1.0)
        canvas.drawHierarchy(in: CGRect(x: 0, y: 0, width: canvas.frame.width, height: canvas.frame.height), afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let ac = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
        ac.title = "Share image to..."
        //AppUtils.topViewController?.present(ac, animated: true, completion: nil)
    }
    
    // MARK: - Configuration
    
    /// Called only once on init. Use it only to configure the UI. Ex: Adding subviews, constraints, gestures, etc.
    private func configureCanvas() {
        backgroundColor = .black
        self.clipsToBounds = false
        
        addSubview(canvas)
        addSubview(selection)
        selection.fillSuperview()
        
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
        canvas.background.configureImage(fromAsset: "test-image")
        layoutInitialize()
    }
    
    // MARK: - UIGestureRecongnizerDelegate
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - Helper Methods

extension GFEditorView {
    public func addImageElement(withImage image: GFImageInfo) {
        let imageElement = GFImageElement(canvas: canvas)
        canvas.addElement(imageElement, at: .zero)
        
        var imageSize = image.urls.last!.imageSize
        let imageAspectRatio = imageSize.width / imageSize.height
        imageSize.width = canvas.canvasSize.width * 0.5
        imageSize.height = imageSize.width / imageAspectRatio
        
        print("Adding image: \(imageSize) ; \(canvas.canvasSize)")
        imageElement.configure(withImage: image, size: imageSize, contentMode: .scaleAspectFill)
    }
}
