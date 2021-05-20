//
//  HomeViewController.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 05/05/21.
//

import UIKit
import GraphicsFramework

class HomeViewController: UIViewController {
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Properties
    
    private let widthField: UITextField = {
        let field = UITextField()
        field.text = ""
        field.overrideUserInterfaceStyle = .dark
        field.borderStyle = .roundedRect
        field.keyboardType = .numberPad
        field.keyboardAppearance = .dark
        field.placeholder = "width"
        return field
    }()
    
    private let heightField: UITextField = {
        let field = UITextField()
        field.text = ""
        field.overrideUserInterfaceStyle = .dark
        field.borderStyle = .roundedRect
        field.keyboardType = .numberPad
        field.keyboardAppearance = .dark
        field.placeholder = "height"
        return field
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create", for: .normal)
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Actions
    
    @objc private func createButtonTapped() {
        if widthField.text == "" || heightField.text == "" || widthField.text == nil || heightField.text == nil {
            widthField.text = "512"
            heightField.text = "512"
        }
        let width = Int(widthField.text!) ?? 512
        let height = Int(heightField.text!) ?? 512
        if width > 4000 || height > 4000 {
            AppUtils.showAlert(title: "Unsupported Resolution", message: "The maximum supported document resolution is 4000 x 4000.")
            return
        }
        let document = GFDocument.create(withResolution: CGSize(width: width, height: height))
        let editingVC = EditingViewController(document)
        AppUtils.pushVCToNavigation(editingVC)
    }
    
    // MARK: - Actions
    
    @objc private func viewTapped() {
        view.endEditing(true)
    }
    
    // MARK: - Configuration
    
    private func configureViewController() {
        view.backgroundColor = .black
        
        view.addSubview(widthField)
        widthField.setDimensions(height: 35, width: 250)
        widthField.center(inView: view, yConstant: -50)
        
        view.addSubview(heightField)
        heightField.setDimensions(height: 35, width: 250)
        heightField.center(inView: view, yConstant: 50)
        
        view.addSubview(createButton)
        createButton.anchor(top: heightField.bottomAnchor, spacingTop: 20)
        createButton.centerX(inView: view)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
        
        configureData()
    }
    
    func configureData() {
        
    }
}
