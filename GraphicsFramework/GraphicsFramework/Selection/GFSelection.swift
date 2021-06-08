//
//  GFSelection.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 07/05/21.
//

import UIKit

public class GFSelection: GFView {
    // MARK: - Lifecycle
    
    init(editor: GFEditorView) {
        self.initialDocumentResolution = editor.document.resolution
        self.currentDocumentResolution = editor.document.resolution
        self.editorView = editor
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    // MARK: - Properties
    
    private weak var editorView: GFEditorView? = nil
    
    private weak var canvas: GFCanvas? {
        return editorView?.canvas
    }
    
    private var initialDocumentResolution: CGSize
    private var currentDocumentResolution: CGSize
    private var initialPanRotation: CGFloat? = nil
    
    private var selectionIndicators: [GFSelectionIndicator] = []
    
    /// Collection of all selected elements.
    public private(set) var selectedElements: [Weak<GFElement>] = []
    
    /// The first selected element.
    public weak var selection: GFElement? {
        return selectedElements.first?.value
    }
    
    /// Returns true if at least one element is selected. False if selection is empty.
    public var isActive: Bool {
        return selection != nil
    }
    
    public private(set) var isSelectionVisible: Bool = true
    
    public var delegates: [Weak<GFSelectionDelegate>] = []
    
    // MARK: - Configuration
    
    /// Called only once on init.
    private func configureView() {
        self.isUserInteractionEnabled = true
        self.clipsToBounds = false
        backgroundColor = .clear
    }
    
    // MARK: - Public API
    
    /// Marks the given element as selected.
    /// - Parameters:
    ///   - element: The element to be selected.
    ///   - additive: If false, then all previuosly selected elements will be deselected before selecting given element. If true, then given element will be added to the selection list.
    public func selectElement(_ element: GFElement, additive: Bool = false, _ invokeDelegate: Bool = true) {
        guard let canvas = canvas else { return }
        let initialSelection = selectedElements.compactMap{ $0.value }
        
        if !additive {
            deselectAllElements(false) // disable delegate invocation
        }
        
        element.internalDelegate = self
        
        let indicator = GFSelectionIndicator(element, parent: self, canvas: canvas)
        addSubview(indicator)
        indicator.layoutInitialize()
        element.elementSelected()
        
        selectionIndicators.append(indicator)
        selectedElements.append(Weak(element))
        
        if !invokeDelegate {
            return
        }
        
        delegates.forEach { delegate in
            delegate.value?.selection?(self, didChangeFrom: initialSelection, to: selectedElements.compactMap{ $0.value })
        }
    }
    
    /// Deselects the element at given index.
    public func deselectElement(at index: Int, _ invokeDelegate: Bool = true) {
        guard let selectedElement = selectedElements[index].value else { return }
        let initialSelection = selectedElements.compactMap{ $0.value }
        let selectionIndicator = selectionIndicators[index]
        
        selectedElement.setEditing(false)
        
        selectionIndicator.removeFromSuperview()
        selectionIndicator.removeAllAnchors()
        selectionIndicators.remove(at: index)
        
        selectedElements.remove(at: index)
        selectedElement.elementDeselected()
        
        selectedElement.internalDelegate = nil
        
        if !invokeDelegate {
            return
        }
        
        delegates.forEach { delegate in
            delegate.value?.selection?(self, didChangeFrom: initialSelection, to: selectedElements.compactMap{ $0.value })
        }
    }
    
    /// Deselects the given element.
    public func deselectElement(_ element: GFElement, _ invokeDelegate: Bool = true) {
        if let index = selectedElements.compactMap({ $0.value }).firstIndex(of: element) {
            deselectElement(at: index, invokeDelegate)
        }
    }
    
    /// Deselects all elements.
    public func deselectAllElements(_ invokeDelegate: Bool = true) {
        if selectedElements.count == 0 {
            return
        }
        
        let initialSelection = selectedElements
        
        for i in (0..<selectedElements.count).reversed() {
            deselectElement(at: i, false) // disable delegate invocation
        }
        
        if !invokeDelegate {
            return
        }
        
        delegates.forEach { delegate in
            delegate.value?.selection?(self, didChangeFrom: initialSelection.compactMap{ $0.value },
                                       to: selectedElements.compactMap{ $0.value })
        }
    }
    
    /// Internal function used to destroy a selection indicator view.
    func destroyIndicator(_ indicator: GFSelectionIndicator) {
        if let index = selectionIndicators.firstIndex(of: indicator) {
            selectionIndicators[index].removeAllAnchors()
            selectionIndicators.remove(at: index)
        }
        indicator.removeFromSuperview()
    }
    
    public func setSelectionVisible(_ visible: Bool) {
        isSelectionVisible = visible
        for indicator in selectionIndicators {
            indicator.isHidden = !visible
            indicator.anchorPoints.forEach { anchorPoint in
                anchorPoint.isHidden = !visible
            }
        }
    }
    
    public func isElementSelected(_ element: GFElement) -> Bool {
        return selectedElements.contains(where: { $0.value == element })
    }
    
    // MARK: - Actions
    
    
    /// Call this function to handle the pan gesture movement for a GFSelectionIndicator or a GFSelectionAnchor.
    /// - Parameters:
    ///   - recognizer: The recognizer object.
    ///   - target: The target GFView. Either GFSelectionIndicator or GFSelectionAchor.
    /// - Returns: Returns true if pan was validated in Selection View, else false.
    @discardableResult func handlePan(_ recognizer: UIPanGestureRecognizer, target: GFView) -> Bool {
        guard let canvas = canvas else { return false }
        guard let editor = canvas.editor else { return false }
        guard let selection = selection else { return false }
        
        if selection.isEditing { // Disable panning for objects that are being edited
            return false
        }
        
        // use .canvas
        if selection.type == .canvas { // Panning shouldn't be allowed for canvas element
            return false
        }
        
        if recognizer.state == .began {
            print("starting recording")
            editor.actionManager.startRecording(elements: selectedElements.compactMap{ $0.value })
        } else if recognizer.state == .ended || recognizer.state == .cancelled || recognizer.state == .failed {
            print("ending recording")
            editor.actionManager.stopRecording()
            
            delegates.forEach { delegate in
                delegate.value?.selectionStateDidChange?(self)
            }
        }
        
        if let target = target as? GFSelectionAnchor {
            
            let translation = recognizer.translation(in: self)
            let resolutionFactor = canvas.resolutionFactor
            let zoomFactor = canvas.zoomFactor
            let widthFactor = zoomFactor * resolutionFactor.width
            let heightFactor = zoomFactor * resolutionFactor.height
            
            // if an achor was dragged
            switch target.anchorPosition {
            case .topLeft:
                selection.originalFrame.origin.x += translation.x / widthFactor
                selection.originalFrame.origin.y += translation.y / heightFactor
                selection.originalFrame.size.width += -translation.x / widthFactor
                selection.originalFrame.size.height += -translation.y / heightFactor
            case .topRight:
                selection.originalFrame.size.width += translation.x / widthFactor
                selection.originalFrame.origin.y += translation.y / heightFactor
                selection.originalFrame.size.height += -translation.y / heightFactor
            case .bottomLeft:
                selection.originalFrame.origin.x += translation.x / widthFactor
                selection.originalFrame.size.width += -translation.x / widthFactor
                selection.originalFrame.size.height += translation.y / heightFactor
            case .bottomRight:
                selection.originalFrame.size.width += translation.x / widthFactor
                selection.originalFrame.size.height += translation.y / heightFactor
            default:
                break
            }
            
            switch target.anchorType {
            // If rotator was dragged
            case .rotator:
                if initialPanRotation == nil {
                    initialPanRotation = selection.rotation
                }
                selection.rotation -= translation.x / widthFactor
            default:
                break
            }
            
            if recognizer.state == .ended || recognizer.state == .cancelled {
                initialPanRotation = nil
            }
            
            editor.layoutUpdate()
            recognizer.setTranslation(.zero, in: self)
            return true
        }
        
        if recognizer.state == .began || recognizer.state == .changed {
            let translation = recognizer.translation(in: self)
            let resolutionFactor = canvas.resolutionFactor
            let zoomFactor = canvas.zoomFactor
            
            selectedElements.compactMap{ $0.value }.forEach { el in
                el.center = CGPoint(x: el.center.x + translation.x / zoomFactor / resolutionFactor.width,
                                    y: el.center.y + translation.y / zoomFactor / resolutionFactor.height)
            }
            
            editor.layoutUpdate()
            
            recognizer.setTranslation(.zero, in: self)
        }
        
        return true
    }
    
    // MARK: - Methods
    
    private func updateSelectionIndicators() {
        var indicatorsToRemove = [GFSelectionIndicator]()
        for indicator in selectionIndicators {
            if indicator.element == nil || indicator.element!.isRemoved {
                indicatorsToRemove.append(indicator)
            }
        }
        
        indicatorsToRemove.forEach { indicator in
            self.destroyIndicator(indicator)
        }
    }
    
    // MARK: - Overrides
    
    override func layoutInitialize() {
        super.layoutInitialize()
        
        selectionIndicators.forEach { indicator in
            indicator.layoutInitialize()
        }
    }
    
    override func layoutUpdate() {
        super.layoutUpdate()
        
        if isSelectionVisible {
            for (i, el) in selectedElements.compactMap({ $0.value }).enumerated() {
                if el.isEditing {
                    selectionIndicators[i].setAnchorsVisible(false)
                }
            }
        }
        
        selectionIndicators.forEach { indicator in
            indicator.layoutUpdate()
        }
    }
    
    override func documentResolutionChanged(from oldRes: CGSize, to newRes: CGSize) {
        super.documentResolutionChanged(from: oldRes, to: newRes)
        self.currentDocumentResolution = newRes
    }
}

// MARK: - GFElementDelegate

extension GFSelection: GFElementDelegate {
    
    public func element(_ element: GFElement, editingModeDidChange editMode: Bool) {
        if let _ = selectedElements.firstIndex(where: { $0.value == element }) {
            self.isUserInteractionEnabled = !editMode
        }
    }
    
}

// MARK: - GFTranslationMode

public enum GFTranslationMode {
    case free
    /// No translation
    case fixed
    
    public static var defaultMode: Self { .free }
}

// MARK: - GFRotationMode

public enum GFRotationMode {
    case free
    /// No rotation
    case fixed
    
    public static var defaultMode: Self { .free }
}

// MARK: - GFResizeMode

public enum GFResizeMode {
    case free
    case maintainAspectRatio
    /// No resize allowed
    case fixed
    
    public static var defaultMode: Self { .free }
}
