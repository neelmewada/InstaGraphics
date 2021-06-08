//
//  GFTextElement.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 05/05/21.
//

import UIKit

public class GFTextElement: GFElement, UITextViewDelegate {
    // MARK: - Lifecycle
    
    override public init(canvas: GFCanvas, id: String? = nil) {
        super.init(canvas: canvas, id: id)
        configureElement()
    }
    
    internal init?(from serializedElement: GFCodableElement, canvas: GFCanvas) {
        super.init(canvas: canvas, id: serializedElement.id)
        if !configure(from: serializedElement) {
            return nil
        }
    }
    
    required init?(coder: NSCoder) { return nil }
    
    
    // MARK: - Properties
    
    public override var type: GFElementType {
        return .text
    }
    
    public override var resizeMode: GFResizeMode {
        return .free
    }
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = "Text"
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textColor = .black
        textView.allowsEditingTextAttributes = true
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
    
    @discardableResult public override func configure(from serializedElement: GFCodableElement) -> Bool {
        if serializedElement.elementType != .text {
            return false
        }
        
        background.configure(from: serializedElement.background)
        
        self.position = serializedElement.position
        self.size = serializedElement.size
        self.rotation = serializedElement.rotation
        
        self.configure(serializedElement.textConfig)
        
        return true
    }
    
    /// Configure the text element from the given configuration.
    /// - Parameter config: The configuration for the text element.
    public func configure(_ config: Configuration) {
        if let fontName = config.fontName {
            textView.font = UIFont(name: fontName, size: config.fontSize)
        } else {
            textView.font = UIFont.systemFont(ofSize: config.fontSize)
        }
        
        textView.textColor = config.textColor.uiColor
        textView.text = config.text
        textViewUpdated()
    }
    
    public func configure(fontSize: CGFloat) {
        textView.font = textView.font?.withSize(fontSize)
        textViewUpdated()
    }
    
    public func getConfiguration() -> Configuration {
        return Configuration(fontName: textView.font?.fontName,
                             fontSize: textView.font?.pointSize ?? 16,
                             textColor: textView.textColor?.gfColor ?? UIColor.black.gfColor,
                             text: textView.text)
    }
    
    // MARK: - Methods
    
    private func textViewUpdated() {
        originalFrame.size = textView.intrinsicContentSize
        
        textView.frame = CGRect(x: 0, y: 0, width: originalFrame.width, height: originalFrame.height)
        canvas?.editor?.layoutUpdate()
    }
    
    override public func setEditing(_ set: Bool) {
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
    
    public override func createDuplicate() -> GFTextElement {
        let duplicate = GFTextElement(canvas: canvas)
        duplicate.configure(from: self.serializedValue)
        return duplicate
    }
    
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
        
    }
    
    override func elementDeselected() {
        super.elementDeselected()
        //setEditing(false)
        
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
