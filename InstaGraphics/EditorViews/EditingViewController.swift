//
//  EditingViewController.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 04/05/21.
//

import UIKit
import GraphicsFramework

class EditingViewController: UIViewController {
    // MARK: - Lifecycle
    
    init(_ document: GFDocument) {
        self.editorView = GFEditorView(document: document)
        super.init(nibName: nil, bundle: nil)
        self.editorPopupView.editorPopupItemView?.setDelegate(self)
    }
    
    required init?(coder: NSCoder) { return nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        view.layoutIfNeeded()
        
        editorView.configure()
        configureAfterLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if viewAppearedAlready {
            return
        }
        
        viewAppearedAlready = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Properties
    
    private let editorView: GFEditorView
    
    private let editorPopupView = EditorTabBarPopupView(popupHeight: 730, contentView: EditorTabBarPhotosView())
    
    private lazy var editorTabBar = EditorTabBar(showCallback: self.showPopupView)
    private let editorToolBar = EditorToolBar()
    private let editorTopBar = EditorTopBar()
    
    private var viewAppearedAlready = false
    
    private let bottomGradient: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.setHeight(height: 210)
        return view
    }()
    
    // MARK: - Configuration
    
    private func configureViewController() {
        view.backgroundColor = .black
        view.clipsToBounds = true
        
        view.addSubview(editorView)
        editorView.fillSuperview()
        
        view.addSubview(bottomGradient)
        bottomGradient.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        view.addSubview(editorToolBar)
        editorToolBar.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, spacingLeft: 20, spacingBottom: 130, spacingRight: 20, height: 75)
        
        view.addSubview(editorTabBar)
        editorTabBar.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, height: 100)
        
        view.addSubview(editorPopupView)
        let popupHeight = editorPopupView.popupHeight
        editorPopupView.frame = CGRect(x: 0, y: AppUtils.orientationHeight, width: AppUtils.orientationWidth, height: popupHeight)
        editorPopupView.configureOnFrameSet()
        
        view.addSubview(editorTopBar)
        editorTopBar.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 100)
        
        editorTopBar.delegate = self
        editorView.selection.delegate = self
        
        layoutTrait(UIScreen.main.traitCollection)
        configureData()
    }
    
    /// Called on viewWillAppear.
    override func configureAfterLayout() {
        let gradientLayer = CAGradientLayer()
        let color = Constants.primaryBlackColor
        gradientLayer.colors = [color.withAlphaComponent(0).cgColor, color.withAlphaComponent(0.5).cgColor, color.withAlphaComponent(1.0).cgColor]
        gradientLayer.locations = [0, 0.2, 0.6]
        let size = bottomGradient.layer.frame.size
        gradientLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        bottomGradient.layer.addSublayer(gradientLayer)
        
        editorTopBar.configureOnAppear()
        editorTabBar.configureOnAppear()
        editorPopupView.configureOnFrameSet()
    }
    
    func configureData() {
        
    }
    
    func showPopupView(_ item: EditorTabBarItem) {
        guard let itemView = item.itemView else { return }
        editorPopupView.setContentView(itemView)
        item.itemView?.setDelegate(self)
        editorPopupView.showAnimated()
    }
    
    func hidePopupView() {
        editorPopupView.hideAnimated()
    }
    
    // MARK: - Layout
    
    private func layoutTrait(_ traitCollection: UITraitCollection) {
        // Activate compact constraints
        if traitCollection.horizontalSizeClass == .compact {
            
        }
        
        // Activate regular constraints
        if traitCollection.horizontalSizeClass == .regular {
            
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layoutTrait(UIScreen.main.traitCollection)
    }
}


// MARK: - EditorTopBarDelegate

extension EditingViewController: EditorTopBarDelegate {
    func backButtonPressed() {
        AppUtils.popVCFromNavigation(animated: true)
    }
    
    func actionButonPressed() {
        editorView.capture()
    }
}

// MARK: - EditorTabBarPhotosViewDelegate

extension EditingViewController: EditorTabBarPhotosViewDelegate {
    func editorTabBarPhotosView(_ view: EditorTabBarPhotosView, didTapOnPhoto photo: GFImageInfo) {
        hidePopupView()
        editorView.addImageElement(withImage: photo)
    }
    
    func editorTabBarPhotosViewShouldDismiss(_ view: EditorTabBarPhotosView) {
        hidePopupView()
    }
}

// MARK: - GFSelectionDelegate

extension EditingViewController: GFSelectionDelegate {
    
}


