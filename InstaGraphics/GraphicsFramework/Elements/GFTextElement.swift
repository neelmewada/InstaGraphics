//
//  GFTextElement.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 05/05/21.
//

import UIKit

public class GFTextElement: GFElement, UITextViewDelegate {
    // MARK: - Lifecycle
    
    override init(canvas: GFCanvas) {
        super.init(canvas: canvas)
        configureElement()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    // MARK: - Properties
    
    public override var type: GFElementType {
        return .text
    }
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = "Text"
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textColor = .black
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isUserInteractionEnabled = false
        textView.keyboardAppearance = .dark
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        textView.delegate = self
        return textView
    }()
    
    public var text: String {
        get { textView.text }
        set {
            textView.text = newValue
            textViewUpdated()
        }
    }
    
    // MARK: - Configuration
    
    private func configureElement() {
        addSubview(textView)
    }
    
    func configure(_ config: GFTextElement.Configuration) {
        if let fontName = config.fontName {
            textView.font = UIFont(name: fontName, size: config.fontSize)
        } else {
            textView.font = UIFont.systemFont(ofSize: config.fontSize)
        }
        textView.textColor = config.textColor
        textView.text = config.initialText
        textViewUpdated()
    }
    
    // MARK: - Methods
    
    private func textViewUpdated() {
        originalFrame.size = textView.intrinsicContentSize
        //frame.size = textView.intrinsicContentSize
        
        textView.frame = CGRect(x: 0, y: 0, width: originalFrame.width, height: originalFrame.height)
        canvas?.editor?.layoutUpdate()
    }
    
    override func setEditing(_ set: Bool) {
        super.setEditing(set)
        textView.isEditable = set
        textView.isUserInteractionEnabled = set
        if set {
            textView.becomeFirstResponder()
        } else {
            textView.resignFirstResponder()
        }
        
        canvas?.editor?.layoutUpdate()
    }
    
    // MARK: - Overrides
    
    override func layoutInitialize() {
        super.layoutInitialize()
        let intrinsicSize = textView.intrinsicContentSize
        frame.size = intrinsicSize
        textView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        
    }
    
    override func layoutUpdate() {
        super.layoutUpdate()
        if isEditing {
            return
        }
        
        textView.frame = CGRect(x: 0, y: 0, width: originalFrame.width, height: originalFrame.height)
        textView.updateFontSizeToFitFrame()
    }
    
    override func viewDoubleTapped() {
        setEditing(true)
        canvas?.editor?.layoutUpdate()
    }
    
    override func elementDeselected() {
        super.elementDeselected()
        setEditing(false)
        
        if text.isEmpty {
            canvas?.removeElement(self)
        }
    }
    
    override func prepareForRender() {
        super.prepareForRender()
    }
    
    // MARK: - UITextViewDelegate
    
    public func textViewDidChange(_ textView: UITextView) {
        textViewUpdated()
    }
}
