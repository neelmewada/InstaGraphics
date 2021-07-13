//
//  EditorTabBarPopupSearchView.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 16/05/21.
//

import UIKit

@objc protocol EditorTabBarPopupSearchFieldDelegate {
    @objc optional func searchFieldDidReturn(_ searchField: EditorTabBarPopupSearchField)
}

public class EditorTabBarPopupSearchField: UIView, UITextFieldDelegate {
    // MARK: - Lifecycle
    
    init(placeholder: String = "Search...") {
        super.init(frame: .zero)
        searchField.placeholder = placeholder
        configureView()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    // MARK: - Properties
    
    weak var delegate: EditorTabBarPopupSearchFieldDelegate? = nil
    
    // MARK: - Views
    
    private let searchIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "search-icon")?.withRenderingMode(.alwaysOriginal)
        return imageView
    }()
    
    private lazy var searchField: UITextField = {
        let field = TextField()
        field.attributedPlaceholder = NSAttributedString(string: "Search...",
                                                         attributes: [.font: UIFont(name: "Roboto-Regular", size: 14)!,
                                                                      .foregroundColor: UIColor.white.withAlphaComponent(0.3)])
        
        field.overrideUserInterfaceStyle = .dark
        field.borderStyle = .none
        field.clipsToBounds = true
        field.layer.borderWidth = 1.0
        field.layer.cornerRadius = 15
        field.layer.borderColor = UIColor.fromHex("303030").cgColor
        field.keyboardAppearance = .dark
        field.keyboardType = .webSearch
        field.leftView = searchIcon
        field.leftView?.anchor()
        field.leftViewMode = .always
        field.delegate = self
        return field
    }()
    
    public var searchText: String? {
        get { searchField.text }
        set { searchField.text = newValue }
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        addSubview(searchField)
        searchField.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, spacingTop: 24, height: 46)
        
        self.anchor(bottom: searchField.bottomAnchor)
    }
    
    // MARK: - UITextFieldDelegate
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        delegate?.searchFieldDidReturn?(self)
        return true
    }
    
    // MARK: - TextField
    
    private class TextField: UITextField {
        let iconPadding = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 0)
        let textPadding = UIEdgeInsets(top: 0, left: 48, bottom: 0, right: 48)
        
        override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
            let rect = bounds.inset(by: iconPadding)
            return CGRect(origin: rect.origin, size: CGSize(width: 20, height: rect.height))
        }
        
        override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: textPadding)
        }
        
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: textPadding)
        }
        
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: textPadding)
        }
    }
}

