//
//  EditorToolBar.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 06/05/21.
//

import UIKit

class EditorToolBar: UIView {
    // MARK: - Lifecycle
    
    init() {
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    // MARK: - Properties
    
    public private(set) var isVisible: Bool = false
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .top
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let backgroundView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let effectsView = UIVisualEffectView(effect: blurEffect)
        effectsView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        return effectsView
    }()
    
    private var sharedConstraints: [NSLayoutConstraint] = []
    private var compactConstraints: [NSLayoutConstraint] = []
    private var regularConstraints: [NSLayoutConstraint] = []
    
    // MARK: - Configuration
    
    private func configureView() {
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        
        addSubview(backgroundView)
        backgroundView.fillSuperview()
        
        self.alpha = 0.0
        self.transform = transform.scaledBy(x: 0.5, y: 0.5).translatedBy(x: 0, y: 80)
        isHidden = true
    }
    
    // MARK: - Methods
    
    func show() {
        if isVisible {
            return
        }
        isVisible = true
        isHidden = false
        
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1.0
            self.transform = self.transform.translatedBy(x: 0, y: -80).scaledBy(x: 2, y: 2)
        }
    }
    
    func hide() {
        if !isVisible {
            return
        }
        isVisible = false
        
        UIView.animate(withDuration: 0.5) {
            self.alpha = 0.0
            self.transform = self.transform.scaledBy(x: 0.5, y: 0.5).translatedBy(x: 0, y: 80)
        } completion: { _ in
            self.isHidden = true
        }
    }
    
    // MARK: - Layout
    
    private func layoutTrait(_ traitCollection: UITraitCollection) {
        if sharedConstraints.count > 0 && !sharedConstraints[0].isActive {
           // Activate shared constraints
           NSLayoutConstraint.activate(sharedConstraints)
        }
        
        // Activate compact constraints
        if traitCollection.horizontalSizeClass == .compact {
            if regularConstraints.count > 0 && regularConstraints[0].isActive {
                NSLayoutConstraint.deactivate(regularConstraints)
            }
            NSLayoutConstraint.activate(compactConstraints)
        }
        
        // Activate regular constraints
        if traitCollection.horizontalSizeClass == .regular {
            if compactConstraints.count > 0 && compactConstraints[0].isActive {
                NSLayoutConstraint.deactivate(compactConstraints)
            }
            NSLayoutConstraint.activate(regularConstraints)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layoutTrait(UIScreen.main.traitCollection)
    }
}
