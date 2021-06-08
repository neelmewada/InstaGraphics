//
//  GFView.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 04/05/21.
//

import UIKit

/// The base class used throughout the GraphicsFramework
public class GFView: UIView {
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = true
        self.autoresizesSubviews = false
    }
    
    required init?(coder: NSCoder) { return nil }
    
    // MARK: - Private Properties
    
    private var _position: CGPoint = .zero
    private var _size: CGSize = .zero
    
    // MARK: - Public Properties
    
    /// Position of the top-left corner of this view. (CGRect.origin)
    public var position: CGPoint {
        get {
            _position = originalFrame.origin
            return _position
        }
        set {
            _position = newValue
            originalFrame.origin = newValue
        }
    }
    
    /// Size of the view. (CGRect.size)
    public var size: CGSize {
        get {
            _size = originalFrame.size
            return _size
        }
        set {
            _size = newValue
            originalFrame.size = newValue
        }
    }
    
    /// Sets or gets the current rotation of the element.
    public var rotation: CGFloat = 0 {
        didSet {
            transform = .init(rotationAngle: rotation * .pi / 180)
        }
    }
    
    /// Returns the original frame of the element by removing the transform.
    public var originalFrame: CGRect {
        get {
            let currTransform = self.transform
            self.transform = .identity
            let originalFrame = self.frame
            self.transform = currTransform
            return originalFrame
        } set(newFrame) {
            let currTransform = self.transform
            self.transform = .identity
            self.frame = newFrame
            self.transform = currTransform
        }
    }
    
    // MARK: - Methods
    
    /// Called only once to setup the layout initially.
    func layoutInitialize() {
        
    }
    
    /// Called when position or bounds of a parent view or the canvas. Use it to update this view.
    func layoutUpdate() {
        
    }
    
    /// Called when the resolution of the document has changed.
    func documentResolutionChanged(from oldRes: CGSize, to newRes: CGSize) {
        
    }
    
    /// Called just before the render. Use it to prepare the view for render.
    func prepareForRender() {
        
    }
    
    /// Called after the render was either finished or failed. Use it to undo the changes from prepareForRender if necessary.
    func unprepareAfterRender() {
        
    }
    
    /// Called when the user single taps this view.
    func viewSingleTapped() {
        
    }
    
    /// Called when the user double taps this view.
    func viewDoubleTapped() {
        
    }
}
