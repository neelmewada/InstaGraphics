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
        editorView.delegate = self
    }
    
    required init?(coder: NSCoder) { return nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController() // Configure UI
        view.layoutIfNeeded() // layout subviews
        
        editorView.configure()
        configureAfterLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Properties
    
    
    
    // MARK: - Views
    
    private let editorView: GFEditorView
    
    private let editorPopupView = EditorTabBarPopupView(popupHeight: 730)
    
    private lazy var editorTabBar = EditorTabBar(delegate: self)
    
    private lazy var editorToolBar = EditorToolBar(editor: editorView, popup: editorToolBarPopup)
    private lazy var editorToolBarPopup = EditorToolBarPopup()
    
    private let editorTopBar = EditorTopBar()
    
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
        editorToolBar.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor,
                             spacingLeft: 20, spacingBottom: 130, spacingRight: 20, height: 75)
        editorToolBar.delegate = self
        
        view.addSubview(editorToolBarPopup)
        
        view.addSubview(editorTabBar)
        editorTabBar.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, height: 100)
        
        view.addSubview(editorPopupView)
        let popupHeight = editorPopupView.popupHeight
        editorPopupView.frame = CGRect(x: 0, y: AppUtils.orientationHeight, width: AppUtils.orientationWidth, height: popupHeight)
        editorPopupView.configureOnFrameSet()
        
        view.addSubview(editorTopBar)
        editorTopBar.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 100)
        
        editorTopBar.delegate = self
        editorView.selection.delegates.append(Weak(self))
        
        layoutTrait(UIScreen.main.traitCollection)
        configureData()
    }
    
    /// Called on viewWillAppear.
    override func configureAfterLayout() {
        let gradientLayer = CAGradientLayer()
        let color = UIColor.brandBlack
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
    
    func showPhotoPopupView() {
        let contentView = EditorTabBarPhotosView()
        editorPopupView.setContentView(contentView)
        editorPopupView.showAnimated()
        contentView.delegate = self
        contentView.loadInitialData()
    }
    
    func hidePopupView() {
        editorPopupView.hideAnimated()
    }
    
    func validateUndoRedo() {
        editorTopBar.undoButton.isEnabled = editorView.operationManager.undosRemaining > 0
        editorTopBar.redoButton.isEnabled = editorView.operationManager.redosRemaining > 0
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

// MARK: - EditorTabBarDelegate

extension EditingViewController: EditorTabBarDelegate {
    
    func editorTabBar(_ editorTabBar: EditorTabBar, didTapOnItem item: EditorTabBarItem) {
        guard let itemView = item.itemView else { return }
        editorPopupView.setContentView(itemView)
        item.itemView?.setDelegate(self)
        editorPopupView.showAnimated()
        itemView.loadInitialData()
    }
}


// MARK: - EditorTopBarDelegate

extension EditingViewController: EditorTopBarDelegate {
    func editorTopBarDidPressBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    func editorTopBarDidPressActionButton() {
        editorView.capture()
    }
    
    func editorTopBarDidPressUndoButton() {
        editorView.operationManager.undoOperation()
        validateUndoRedo()
    }
    
    func editorTopBarDidPressRedoButton() {
        editorView.operationManager.redoOperation()
        validateUndoRedo()
    }
}

// MARK: - GFEditorViewDelegate

extension EditingViewController: GFEditorViewDelegate {
    
    func editorViewDidChange(_ editorView: GFEditorView) {
        validateUndoRedo()
    }
    
}

// MARK: - EditorTabBarPhotosViewDelegate

extension EditingViewController: EditorTabBarPhotosViewDelegate {
    
    func editorTabBarPhotosView(_ view: EditorTabBarPhotosView, didTapOnPhoto photo: GFCodableImage) {
        hidePopupView()
        editorView.addImageElement(withImage: photo)
    }
    
    func editorTabBarPhotosViewShouldDismiss(_ view: EditorTabBarPhotosView) {
        hidePopupView()
    }
}

// MARK: - GFSelectionDelegate

extension EditingViewController: GFSelectionDelegate {
    
    func selection(_ selection: GFSelection, didChangeFrom initialSelection: [GFElement], to finalSelection: [GFElement]) {
        if let selectedElement = selection.selection, selection.isActive,
           let context = selectedElement as? EditorToolBarContext {
            editorToolBar.configure(context)
            editorToolBar.show()
        } else { // failed to cast context
            editorToolBar.hide()
        }
    }
    
    func selectionStateDidChange(_ selection: GFSelection) {
        validateUndoRedo()
    }
}

// MARK: - EditorToolBarDelegate

extension EditingViewController: EditorToolBarDelegate {
    
    func editorToolBarRequestsPhotoPicker(_ toolBar: EditorToolBar, for elements: [GFElement]) {
        let photoPickerView = EditorPhotoPickerSlideUpView(popupHeight: 730)
        view.addSubview(photoPickerView)
        photoPickerView.show()
        
    }
    
}


