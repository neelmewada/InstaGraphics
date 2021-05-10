//
//  EditingViewController.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 04/05/21.
//

import UIKit

class EditingViewController: UIViewController, EditorTopBarDelegate {
    // MARK: - Lifecycle
    
    init(_ document: GFDocument) {
        self.editorView = GFEditorView(document: document)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { return nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if viewAppeared {
            return
        }
        // configure the editor view once
        let config = GFEditorView.Configuration()
        editorView.configure(config)
        configureOnAppear()
        viewAppeared = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Properties
    
    private let editorView: GFEditorView
    
    private let editorTabBar = EditorTabBar()
    private let editorToolBar = EditorToolBar()
    private let editorTopBar = EditorTopBar()
    
    private var viewAppeared = false
    
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
        
        view.addSubview(editorTabBar)
        editorTabBar.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, height: 100)
        
        view.addSubview(editorToolBar)
        editorToolBar.anchor(left: view.leftAnchor, bottom: editorTabBar.topAnchor, right: view.rightAnchor, spacingLeft: 20, spacingBottom: 40, spacingRight: 20, height: 75)
        
        view.addSubview(editorTopBar)
        editorTopBar.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 100)
        
        editorTopBar.delegate = self
        
        layoutTrait(UIScreen.main.traitCollection)
        configureData()
    }
    
    /// Called on viewWillAppear
    private func configureOnAppear() {
        let gradientLayer = CAGradientLayer()
        let color = Constants.primaryBlackColor
        gradientLayer.colors = [color.withAlphaComponent(0).cgColor, color.withAlphaComponent(0.5).cgColor, color.withAlphaComponent(1.0).cgColor]
        gradientLayer.locations = [0, 0.2, 0.6]
        let size = bottomGradient.layer.frame.size
        gradientLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        bottomGradient.layer.addSublayer(gradientLayer)
        
        editorTopBar.configureOnAppear()
    }
    
    func configureData() {
        
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
    
    // MARK: - EditorTopBarDelegate
    
    func backButtonPressed() {
        AppUtils.popVCFromNavigation(animated: true)
    }
    
    func actionButonPressed() {
        editorView.capture()
    }
}
