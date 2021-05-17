//
//  EditorTabBar.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 06/05/21.
//

import UIKit

class EditorTabBar: UIView {
    // MARK: - Lifecycle
    
    init(showCallback: @escaping (EditorTabBarItem) -> ()) {
        self.showCallback = showCallback
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    // MARK: - Properties
    
    private let showCallback: (EditorTabBarItem) -> ()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        return stack
    }()
    
    public lazy var tabItems: [EditorTabBarItem] = [
        EditorTabBarItem(imageName: "image-icon", text: "Photos", itemView: EditorTabBarPhotosView()),
        EditorTabBarItem(imageName: "upload-icon", text: "Uploads", itemView: EditorTabBarPhotosView()),
        EditorTabBarItem(imageName: "text-icon", text: "Text", itemView: EditorTabBarPhotosView()),
        EditorTabBarItem(imageName: "sticker-icon", text: "Sticker", itemView: EditorTabBarPhotosView()),
        EditorTabBarItem(imageName: "shape-icon", text: "Shapes", itemView: EditorTabBarPhotosView()),
    ]
        
    public private(set) var isShown: Bool = false
    
    private var popupOffset: CGFloat = 0
    
    private var sharedConstraints: [NSLayoutConstraint] = []
    private var compactConstraints: [NSLayoutConstraint] = []
    private var regularConstraints: [NSLayoutConstraint] = []
    
    private var popupBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Configuration
    
    private func configureView() {
        isShown = false
        
        addSubview(stackView)
        compactConstraints.append(contentsOf: stackView.anchorConstraints(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, spacingLeft: 20, spacingBottom: 36, spacingRight: 20, activateConstraints: false))
        regularConstraints.append(contentsOf: stackView.anchorConstraints(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, spacingLeft: 74, spacingBottom: 36, spacingRight: 74, activateConstraints: false))
        stackView.setHeight(height: 56)
        
        for item in tabItems {
            stackView.addArrangedSubview(item)
            item.setTapHandler(self.tabBarItemTapped)
        }
        
        layoutTrait(UIScreen.main.traitCollection)
    }
    
    func configureOnAppear() {
        
    }
    
    // MARK: - Methods
    
    private func tabBarItemTapped(item: EditorTabBarItem) {
        if let index = tabItems.firstIndex(of: item) {
            showCallback(item)
        }
    }
    
    private func hidePopupView() {
        
    }
    
    // MARK: - Layout
    
    private func layoutTrait(_ traitCollection: UITraitCollection) {
        if sharedConstraints.count > 0 && !sharedConstraints[0].isActive {
           // activating shared constraints
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

// MARK: - EditorTabBarItemView Protocol

protocol EditorTabBarItemView {
    
}



