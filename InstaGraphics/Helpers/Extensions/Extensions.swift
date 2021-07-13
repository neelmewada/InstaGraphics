//
//  Extensions.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 04/05/21.
//

import Foundation
import UIKit

// MARK: - UIView

extension UIView {
    /// Sets up all the constraints with the corresponding supplied anchors (non-nil values) and spacings
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                spacingTop: CGFloat = 0,
                spacingLeft: CGFloat = 0,
                spacingBottom: CGFloat = 0,
                spacingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil,
                priority: UILayoutPriority = .required) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: spacingTop).withPriority(priority).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: spacingLeft).withPriority(priority).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -spacingBottom).withPriority(priority).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -spacingRight).withPriority(priority).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).withPriority(priority).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).withPriority(priority).isActive = true
        }
    }
    
    @discardableResult
    func anchors(top: NSLayoutYAxisAnchor? = nil,
                 left: NSLayoutXAxisAnchor? = nil,
                 bottom: NSLayoutYAxisAnchor? = nil,
                 right: NSLayoutXAxisAnchor? = nil,
                 spacingTop: CGFloat = 0,
                 spacingLeft: CGFloat = 0,
                 spacingBottom: CGFloat = 0,
                 spacingRight: CGFloat = 0,
                 centerX: NSLayoutXAxisAnchor? = nil,
                 centerXOffset: CGFloat = 0,
                 centerY: NSLayoutYAxisAnchor? = nil,
                 centerYOffset: CGFloat = 0,
                 width: CGFloat? = nil,
                 height: CGFloat? = nil,
                 activateConstraints: Bool = true) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            constraints.append(topAnchor.constraint(equalTo: top, constant: spacingTop))
        }
        
        if let left = left {
            constraints.append(leftAnchor.constraint(equalTo: left, constant: spacingLeft))
        }
        
        if let bottom = bottom {
            constraints.append(bottomAnchor.constraint(equalTo: bottom, constant: -spacingBottom))
        }
        
        if let right = right {
            constraints.append(rightAnchor.constraint(equalTo: right, constant: -spacingRight))
        }
        
        if let centerX = centerX {
            constraints.append(centerXAnchor.constraint(equalTo: centerX, constant: centerXOffset))
        }
        
        if let centerY = centerY {
            constraints.append(centerYAnchor.constraint(equalTo: centerY, constant: centerYOffset))
        }
        
        if let width = width {
            constraints.append(widthAnchor.constraint(equalToConstant: width))
        }
        
        if let height = height {
            constraints.append(heightAnchor.constraint(equalToConstant: height))
        }
        
        if activateConstraints {
            for constraint in constraints {
                constraint.isActive = true
            }
        }
        
        return constraints
    }
    
    func centerInSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            center(inView: superview)
        }
    }
    
    /// Center the view horizontally and vertically with an optional vertical offset with respect to `inView`
    func center(inView view: UIView, yConstant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant!).isActive = true
    }
    
    /// Center the view horizontally with respect to `inView`
    func centerX(inView view: UIView, topAnchor: NSLayoutYAxisAnchor? = nil, spacingTop: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: spacingTop!).isActive = true
        }
    }
    
    /// Center the view vertically with respect to `inView`
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil,
                 spacingLeft: CGFloat = 0, constant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        
        if let left = leftAnchor {
            anchor(left: left, spacingLeft: spacingLeft)
        }
    }
    
    /// Set width and height constraints
    func setDimensions(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func setHeight(minHeight: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight).isActive = true
    }
    
    func setHeight(maxHeight: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(lessThanOrEqualToConstant: maxHeight).isActive = true
    }
    
    func setHeight(height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func setWidth(minWidth: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(greaterThanOrEqualToConstant: minWidth).isActive = true
    }
    
    func setWidth(maxWidth: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth).isActive = true
    }
    
    func setWidth(width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    /// Make this view fill the entire superview perfectly. It modifies top, left, bottom and right anchor constraints.
    func fillSuperview(insets: [Inset] = []) {
        translatesAutoresizingMaskIntoConstraints = false
        guard let view = superview else { return }
        var leftOffset: CGFloat = 0
        var rightOffset: CGFloat = 0
        var topOffset: CGFloat = 0
        var bottomOffset: CGFloat = 0
        for inset in insets {
            (topOffset, leftOffset, bottomOffset, rightOffset) = inset.getEdgeInsets()
        }
        anchor(top: view.topAnchor, left: view.leftAnchor,
               bottom: view.bottomAnchor, right: view.rightAnchor,
               spacingTop: topOffset, spacingLeft: leftOffset,
               spacingBottom: bottomOffset, spacingRight: rightOffset)
    }
    
    /// Make this view fill the entire superview according to the safeAreaLayoutGuide. It modifies top, left, bottom and right anchor constraints.
    func fillSuperviewSafe() {
        translatesAutoresizingMaskIntoConstraints = false
        guard let view = superview else { return }
        anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor,
               bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor)
    }
    
    func removeAllConstraints() {
        NSLayoutConstraint.deactivate(constraints)
    }
    
    enum Inset {
        case top(CGFloat)
        case left(CGFloat)
        case bottom(CGFloat)
        case right(CGFloat)
        case vertical(CGFloat)
        case horizontal(CGFloat)
        case all(CGFloat)
        
        func getEdgeInsets() -> (top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
            var leftOffset: CGFloat = 0
            var rightOffset: CGFloat = 0
            var topOffset: CGFloat = 0
            var bottomOffset: CGFloat = 0
            switch self {
            case .top(let v): topOffset = v
            case .left(let v): leftOffset = v
            case .right(let v): rightOffset = v
            case .bottom(let v): bottomOffset = v
            case .all(let v): topOffset = v; leftOffset = v; rightOffset = v; bottomOffset = v
            case .horizontal(let v): leftOffset = v; rightOffset = v
            case .vertical(let v): topOffset = v; bottomOffset = v
            }
            return (topOffset, leftOffset, bottomOffset, rightOffset)
        }
    }
}

// MARK: - NSLayoutConstraint

extension NSLayoutConstraint {
    func withPriority(_ priority: UILayoutPriority) -> Self {
        self.priority = priority
        return self
    }
}

// MARK: - UIViewController

extension UIViewController {
    @objc func configureAfterLayout() {
        
    }
}

// MARK: - UIButton

extension UIButton {
    private func image(withColor color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        self.setBackgroundImage(image(withColor: color), for: state)
    }
}
