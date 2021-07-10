//
//  EditorToolBar.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 06/05/21.
//

import UIKit
import GraphicsFramework

class EditorToolBar: UIView {
    // MARK: - Lifecycle
    
    init(editor: GFEditorView) {
        self.editor = editor
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    // MARK: - Properties
    
    typealias Delegate = EditorToolBarDelegate
    
    public private(set) var isVisible: Bool = false
    
    public weak var delegate: Delegate? = nil
    
    public private(set) var context: EditorToolBarContext? = nil
    
    private weak var editor: GFEditorView!
    
    /// List of currently visible ToolBar Items.
    private var toolBarItems: [EditorToolBarItem] = []
    
    // MARK: - Configuration
    
    private func configureView() {
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        
        addSubview(backgroundView)
        backgroundView.fillSuperview()
        
        addSubview(scrollView)
        scrollView.fillSuperview()
        
        scrollView.addSubview(stackView)
        stackView.fillSuperview()
        
        // Hide tab bar initially
        self.alpha = 0.0
        self.transform = transform.scaledBy(x: 0.5, y: 0.5).translatedBy(x: 0, y: 80)
        isHidden = true
    }
    
    /// Configure the tool bar for the given context.
    /// - Parameter context: The context is used to display the appropriate list of toolbar items. Could be a GFElement subclass or a custom context.
    public func configure(_ context: EditorToolBarContext) {
        self.context = context
        
        for view in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        let items = context.createToolBarItems()
        
        for item in items {
            let itemView = EditorToolBarItemView(toolBar: self)
            itemView.configure(item)
            stackView.addArrangedSubview(itemView)
        }
        
        self.setNeedsLayout()
        self.layoutIfNeeded() // update layout to get accurate contentSize
        
        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
        scrollView.contentInset = UIEdgeInsets(top: 12, left: offsetX, bottom: 12, right: 0)
    }
    
    // MARK: - Actions
    
    func performAction(_ action: GFAction) {
        editor.performActionOnSelection(action)
    }
    
    // MARK: - Methods
    
    func show() {
        if isVisible {
            return
        }
        
        isVisible = true
        isHidden = false
        
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1.0
            self.transform = self.transform.translatedBy(x: 0, y: -80).scaledBy(x: 2, y: 2)
        }
    }
    
    func hide() {
        if !isVisible {
            return
        }
        
        isVisible = false
        
        UIView.animate(withDuration: 0.25) {
            self.alpha = 0.0
            self.transform = self.transform.scaledBy(x: 0.5, y: 0.5).translatedBy(x: 0, y: 80)
        } completion: { _ in
            self.isHidden = true
        }
    }
    
    // MARK: - Views
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = 0
        return stack
    }()
    
    private let backgroundView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let effectsView = UIVisualEffectView(effect: blurEffect)
        effectsView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        return effectsView
    }()
    
    // MARK: - Size Classes
    
    private var sharedConstraints: [NSLayoutConstraint] = []
    private var compactConstraints: [NSLayoutConstraint] = []
    private var regularConstraints: [NSLayoutConstraint] = []
    
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

// MARK: - EditorToolBarDelegate

@objc protocol EditorToolBarDelegate {
    
    
}
