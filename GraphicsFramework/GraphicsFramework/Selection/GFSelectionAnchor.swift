//
//  GFSelectionAnchor.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 08/05/21.
//

import UIKit

public class GFSelectionAnchor: GFView {
    // MARK: - Lifecycle
    
    init(_ indicator: GFSelectionIndicator, parent: GFSelection, type: GFSelectionAnchorType, position: GFSelectionAnchorPosition) {
        self.indicator = indicator
        self.anchorType = type
        self.anchorPosition = position
        super.init(frame: .zero)
        parent.addSubview(self)
        configureAnchor()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    // MARK: - Properties
    
    private weak var indicator: GFSelectionIndicator? = nil
    
    private weak var canvas: GFCanvas? {
        return indicator?.canvas
    }
    
    public private(set) var anchorType: GFSelectionAnchorType
    
    public private(set) var anchorPosition: GFSelectionAnchorPosition
    
    public var isEnabled: Bool {
        get { return isUserInteractionEnabled }
        set { isUserInteractionEnabled = newValue }
    }
    
    private let anchorView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.isUserInteractionEnabled = false
        view.backgroundColor = GFConstants.anchorFillColor
        view.layer.borderColor = GFConstants.anchorStrokeColor.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    // MARK: - Configuration
    
    private func configureAnchor() {
        backgroundColor = .clear
        isEnabled = true
        guard let indicator = indicator else { return }
        let parentFrame = indicator.originalFrame
        
        var anchorPos = getAnchorCenter(parentFrame: parentFrame)
        anchorPos = indicator.convert(anchorPos, to: superview)
        
        addSubview(anchorView)
        anchorView.centerInParent()
        
        switch anchorType {
        case .circle:
            anchorView.layer.cornerRadius = 7
            anchorView.setDimensions(height: 14, width: 14)
        case .rotator:
            anchorView.layer.cornerRadius = 10
            anchorView.setDimensions(height: 20, width: 20)
            
            let imageView = UIImageView(image: UIImage(named: "rotate-icon")?.withRenderingMode(.alwaysTemplate).withTintColor(.black))
            imageView.isUserInteractionEnabled = false
            anchorView.addSubview(imageView)
            imageView.contentMode = .scaleAspectFit
            imageView.setDimensions(height: 14, width: 14)
            imageView.centerInParent()
        default:
            break
        }
        
        originalFrame.origin = .zero
        originalFrame.size = CGSize(width: 28, height: 28)
        self.rotation = indicator.rotation
        center = anchorPos
    }
    
    // MARK: - Methods
    
    private func getAnchorCenter(parentFrame: CGRect) -> CGPoint {
        var anchorPos = CGPoint()
        
        switch anchorPosition {
        case .topLeft:
            anchorPos = .zero
        case .topRight:
            anchorPos = CGPoint(x: parentFrame.width, y: 0)
        case .bottomLeft:
            anchorPos = CGPoint(x: 0, y: parentFrame.height)
        case .bottomRight:
            anchorPos = CGPoint(x: parentFrame.width, y: parentFrame.height)
        case .top:
            anchorPos = CGPoint(x: parentFrame.width / 2, y: 0)
        case .left:
            anchorPos = CGPoint(x: 0, y: parentFrame.height / 2)
        case .right:
            anchorPos = CGPoint(x: parentFrame.width, y: parentFrame.height / 2)
        case .bottom:
            anchorPos = CGPoint(x: parentFrame.width / 2, y: parentFrame.height)
        case .stack(let index, let count):
            let offset = index - (count - 1) / 2
            let posX = parentFrame.width / 2
            anchorPos = CGPoint(x: posX + CGFloat(offset) * 50, y: parentFrame.height + 30)
            break
        }
        
        return anchorPos
    }
    
    // MARK: - Layout
    
    override func layoutInitialize() {
        super.layoutInitialize()
    }
    
    override func layoutUpdate() {
        super.layoutUpdate()
        guard let indicator = indicator else { return }
        let parentFrame = indicator.originalFrame
        
        var anchorPos = getAnchorCenter(parentFrame: parentFrame)
        anchorPos = indicator.convert(anchorPos, to: superview)
        self.rotation = indicator.rotation
        center = anchorPos
    }
}

// MARK: - GFSelectionAnchorType

public enum GFSelectionAnchorType {
    case circle
    case rectangle
    case rotator
    case translator
}

// MARK: - GFSelectionAnchorPosition

public enum GFSelectionAnchorPosition {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    case top
    case left
    case bottom
    case right
    case stack(Int, Int) // index, count
}
