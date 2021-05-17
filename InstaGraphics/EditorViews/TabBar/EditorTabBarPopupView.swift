//
//  EditorTabBarPopupView.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 16/05/21.
//

import UIKit

class EditorTabBarPopupView: UIView {
    // MARK: - Lifecycle
    
    init(popupHeight: CGFloat) {
        self.popupHeight = popupHeight
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    // MARK: - Properties
    
    private let gradientView: UIView = {
        let view = UIView()
        view.setHeight(height: 100)
        return view
    }()
    
    public lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.primaryBlackColor
        let layer = CAShapeLayer()
        layer.fillColor = Constants.primaryGrayColor.cgColor
        let width: CGFloat = 64
        layer.path = UIBezierPath(roundedRect: CGRect(x: AppUtils.orientationWidth / 2 - width / 2, y: 4, width: width, height: 4), cornerRadius: 2).cgPath
        view.layer.addSublayer(layer)
        return view
    }()
    
    private let contentView = UIView()
    
    private let editorPopupPhotosView = EditorTabBarPhotosView()
    
    public var popupHeight: CGFloat
    
    public private(set) var isShown = false
    
    // MARK: - Configuration
    
    private func configureView() {
        backgroundColor = .clear
        self.clipsToBounds = false
        
        addSubview(gradientView)
        gradientView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 100)
        
        addSubview(containerView)
        containerView.anchor(top: gradientView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
        containerView.addSubview(contentView)
        contentView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, spacingLeft: 20, spacingBottom: 110, spacingRight: 20)
        
        contentView.addSubview(editorPopupPhotosView)
        editorPopupPhotosView.fillSuperview()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
    }
    
    /// Call this function just after the frame of `this` view is set.
    func configureOnFrameSet() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        let color = Constants.primaryBlackColor
        gradientLayer.colors = [color.withAlphaComponent(0).cgColor,
                                color.withAlphaComponent(0.5).cgColor,
                                color.withAlphaComponent(0.75).cgColor,
                                color.withAlphaComponent(1).cgColor]
        gradientLayer.locations = [0, 0.35, 0.55, 1]
        gradientLayer.frame = gradientView.frame
        gradientView.layer.addSublayer(gradientLayer)
        
        editorPopupPhotosView.configureOnLayout()
    }
    
    func show() {
        if isShown {
            return
        }
        
        isShown = true
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.frame.origin.y -= self.popupHeight
        }
    }
    
    func hide() {
        if !isShown {
            return
        }
        
        isShown = false
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.frame.origin.y += self.popupHeight
        }
    }
    
    // MARK: - Actions
    
    @objc private func handleTap(_ tapGesture: UITapGestureRecognizer) {
        self.endEditing(true)
    }
}
