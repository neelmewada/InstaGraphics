//
//  EditorSlideUpView.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 12/07/21.
//

import UIKit

class EditorSlideUpView: UIView {
    // MARK: - Lifecycle
    
    init(popupHeight: CGFloat) {
        self.popupHeight = popupHeight
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    // MARK: - Properties
    
    public var popupHeight: CGFloat
    
    private var hidePos: CGFloat = 0
    private var showPos: CGFloat = 0
    private var panDirection: CGFloat = 0
    private var prevTranslationY: CGFloat = 0
    
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
        contentView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, spacingLeft: 20, spacingBottom: 50, spacingRight: 20)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(panGesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        let color = UIColor.brandBlack
        gradientLayer.colors = [color.withAlphaComponent(0).cgColor,
                                color.withAlphaComponent(0.5).cgColor,
                                color.withAlphaComponent(0.75).cgColor,
                                color.withAlphaComponent(1).cgColor]
        gradientLayer.locations = [0, 0.35, 0.55, 1]
        gradientLayer.frame = gradientView.frame
        gradientView.layer.addSublayer(gradientLayer)
        
        showPos = self.frame.origin.y - self.popupHeight
        hidePos = self.frame.origin.y
    }
    
    // MARK: - Methods
    
    func show() {
        if isShown { return }
        
        layer.removeAllAnimations()
        
        isShown = true
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.frame.origin.y = self.showPos
        }
    }
    
    func hide() {
        if !isShown { return }
        
        layer.removeAllAnimations()
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.1) {
            self.frame.origin.y = self.hidePos
        } completion: { _ in
            self.isShown = false
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func handleTap(_ tapGesture: UITapGestureRecognizer) {
        self.endEditing(true)
    }
    
    @objc
    private func handlePan(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: self)
        
        if panGesture.state == .ended || panGesture.state == .cancelled {
            if panDirection < 0 && translation.y < 150 {
                show()
            } else {
                hide()
            }
            return
        }
        
        if panGesture.state == .began || panGesture.state == .changed {
            let transY = (translation.y > 0) ? translation.y : 0
            self.frame.origin.y = self.showPos + transY
            panDirection = translation.y - prevTranslationY
            prevTranslationY = translation.y
        }
    }
    
    // MARK: - Views
    
    let contentView = UIView()
    
    private let gradientView: UIView = {
        let view = UIView()
        view.setHeight(height: 100)
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.brandBlack
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.brandGray.cgColor
        let width: CGFloat = 64
        layer.path = UIBezierPath(roundedRect: CGRect(x: AppUtils.orientationWidth / 2 - width / 2, y: 4, width: width, height: 4), cornerRadius: 2).cgPath
        view.layer.addSublayer(layer)
        return view
    }()
}
