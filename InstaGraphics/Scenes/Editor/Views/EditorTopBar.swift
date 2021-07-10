//
//  EditorTopBar.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 06/05/21.
//

import UIKit

class EditorTopBar: UIView {
    // MARK: - Lifecycle
    
    init() {
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    // MARK: - Properties
    
    public var delegate: EditorTopBarDelegate? = nil
    
    
    // MARK: - Configuration
    
    private func configureView() {
        addSubview(topGradient)
        topGradient.fillSuperview()
        
        addSubview(backButton)
        backButton.anchor(left: leftAnchor, bottom: bottomAnchor, spacingLeft: 20, spacingBottom: 14, width: 30, height: 30)
        
        addSubview(undoButton)
        undoButton.isEnabled = false
        undoButton.anchor(bottom: bottomAnchor, right: centerXAnchor, spacingBottom: 14)
        
        addSubview(redoButton)
        redoButton.isEnabled = false
        redoButton.anchor(left: centerXAnchor, bottom: bottomAnchor, spacingBottom: 14)
        
        addSubview(redoButton)
        
        addSubview(gradientView)
        gradientView.setDimensions(height: 30, width: 100)
        gradientView.clipsToBounds = true
        gradientView.layer.cornerRadius = 10
        gradientView.anchor(bottom: bottomAnchor, right: rightAnchor, spacingBottom: 14, spacingRight: 20)
        
        addSubview(actionButton)
        actionButton.anchor(bottom: bottomAnchor, right: rightAnchor, spacingBottom: 14, spacingRight: 20)
    }
    
    func configureOnAppear() {
        let color = kPrimaryBlackColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [color.withAlphaComponent(1).cgColor, color.withAlphaComponent(0).cgColor]
        gradientLayer.locations = [0.4, 1]
        
        let size = topGradient.layer.frame.size
        gradientLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        topGradient.layer.addSublayer(gradientLayer)
        
        let buttonGradient = CAGradientLayer()
        buttonGradient.frame = CGRect(x: 0, y: 0, width: gradientView.frame.width, height: gradientView.frame.height)
        buttonGradient.colors = [UIColor.fromHex("9625CC").cgColor, UIColor.fromHex("522ACA").cgColor]
        buttonGradient.locations = [0, 1]
        buttonGradient.startPoint = CGPoint(x: 0, y: 0)
        buttonGradient.endPoint = CGPoint(x: 1, y: 1)
        gradientView.layer.addSublayer(buttonGradient)
    }
    
    // MARK: - Actions
    
    @objc private func backButtonPressed() {
        delegate?.editorTopBarDidPressBackButton?()
    }
    
    @objc private func actionButtonPressed() {
        delegate?.editorTopBarDidPressActionButton?()
    }
    
    @objc private func undoButtonPressed() {
        delegate?.editorTopBarDidPressUndoButton?()
    }
    
    @objc private func redoButtonPressed() {
        delegate?.editorTopBarDidPressRedoButton?()
    }
    
    // MARK: - Views
    
    private let topGradient = UIView()
    
    private let gradientView = UIView()
    
    public lazy var backButton: UIButton = {
        let button = UIButton()
        button.setTitle(nil, for: .normal)
        let image = UIImage(named: "left-arrow")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.imageView?.setDimensions(height: 20, width: 20)
        button.imageView?.centerInSuperview()
        button.setDimensions(height: 30, width: 30)
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        return button
    }()
    
    public lazy var undoButton: UIButton = {
        let button = UIButton()
        button.setTitle(nil, for: .normal)
        let image = UIImage(named: "undo-icon")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image?.withTintColor(.white), for: .normal)
        button.setImage(image?.withTintColor(.init(white: 1, alpha: 0.2)), for: .disabled)
        button.imageView?.setDimensions(height: 20, width: 20)
        button.imageView?.centerInSuperview()
        button.setDimensions(height: 30, width: 30)
        button.addTarget(self, action: #selector(undoButtonPressed), for: .touchUpInside)
        return button
    }()
    
    public lazy var redoButton: UIButton = {
        let button = UIButton()
        button.setTitle(nil, for: .normal)
        let image = UIImage(named: "redo-icon")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image?.withTintColor(.white), for: .normal)
        button.setImage(image?.withTintColor(.init(white: 1, alpha: 0.2)), for: .disabled)
        button.imageView?.setDimensions(height: 20, width: 20)
        button.imageView?.centerInSuperview()
        button.setDimensions(height: 30, width: 30)
        button.addTarget(self, action: #selector(redoButtonPressed), for: .touchUpInside)
        return button
    }()
    
    public lazy var actionButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 14)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.4), for: .highlighted)
        button.setTitle("Save", for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.setDimensions(height: 30, width: 100)
        button.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
        return button
    }()
}

// MARK: - EditorTopBarDelegate

@objc protocol EditorTopBarDelegate {
    @objc optional func editorTopBarDidPressBackButton()
    @objc optional func editorTopBarDidPressUndoButton()
    @objc optional func editorTopBarDidPressRedoButton()
    @objc optional func editorTopBarDidPressActionButton()
}
