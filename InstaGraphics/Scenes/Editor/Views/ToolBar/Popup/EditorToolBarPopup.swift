//
//  EditorToolBarPopup.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 10/07/21.
//

import UIKit

class EditorToolBarPopup: UIView {
    // MARK: - Lifecycle
    
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    // MARK: - Properties
    
    private var popupConstraints = [NSLayoutConstraint]()
    
    private(set) var isShown = false
    private(set) weak var targetItemView: EditorToolBarItemView? = nil
    
    // MARK: - Configuration
    
    struct Configuration {
        var title: String? = nil
        var sizeMode: SizeMode = .minWidth
    }
    
    enum SizeMode {
        case minWidth
        case fullWidth
    }
    
    private func configureUI() {
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        self.backgroundColor = .clear
        
        addSubview(backgroundView)
        backgroundView.fillSuperview()
        
        addSubview(stackView)
        stackView.fillSuperview(insets: [.all(16)])
        
        // hide popup initially
        self.alpha = 0
    }
    
    /// Removes the popup constraints and all controls.
    func reset() {
        NSLayoutConstraint.deactivate(popupConstraints)
        popupConstraints.removeAll()
        
        for view in stackView.arrangedSubviews { // clear stack view
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        titleLabel.removeFromSuperview()
        titleLabel.removeAllConstraints()
        titleBackground.removeFromSuperview()
        titleBackground.removeAllConstraints()
    }
    
    /// Call this function to configure the popup and populate the controls
    func configure(_ config: Configuration, itemView: EditorToolBarItemView, controls: [ControlBuilder]) {
        guard let superview = superview else {
            fatalError("ERROR: configure(_:controls:) called on EditorToolBarPopup before adding it as a subview (i.e. superview is nil)")
        }
        
        targetItemView = itemView
        
        reset()
        
        switch config.sizeMode {
        case .minWidth:
            popupConstraints.append(contentsOf: anchors(bottom: itemView.topAnchor, spacingBottom: 36, centerX: itemView.centerXAnchor))
        case .fullWidth:
            popupConstraints.append(contentsOf: anchors(left: superview.leftAnchor, bottom: itemView.topAnchor, right: superview.rightAnchor,
                                                        spacingLeft: 20, spacingBottom: 24, spacingRight: 20))
        }
        
        NSLayoutConstraint.activate(popupConstraints)
        
        for control in controls {
            if let view = control.view {
                stackView.addArrangedSubview(view)
                if let spacing = control.spacing {
                    stackView.setCustomSpacing(spacing, after: view)
                }
            } else if let spacing = control.spacing,
                      let lastSubview = stackView.arrangedSubviews.last {
                stackView.setCustomSpacing(spacing, after: lastSubview)
            }
        }
        
        layoutIfNeeded()
    }
    
    // MARK: - Methods
    
    func show() {
        if isShown { return }
        
        self.layer.removeAllAnimations()
        
        isShown = true
        alpha = 0
        transform = .init(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
            self.transform = .init(scaleX: 1, y: 1)
        }
    }
    
    func hide(reset: Bool = true) {
        if !isShown { return }
        
        self.layer.removeAllAnimations()
        
        isShown = false
        
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0
            self.transform = .init(scaleX: 0, y: 0)
        } completion: { completed in
            if completed && reset { self.reset() }
        }
    }
    
    // MARK: - Views
    
    private let backgroundView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        return view
    }()
    
    private let titleBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .fromHex("0F0F0F", alpha: 0.25)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 12)
        label.textColor = .white
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 16
        stack.axis = .horizontal
        stack.alignment = .fill
        return stack
    }()
}
