//
//  GFAction.swift
//  GraphicsFramework
//
//  Created by Neel Mewada on 01/06/21.
//

import UIKit

// MARK: - GFAction Protocol

@objc public protocol GFAction: AnyObject {
    
    @objc func isValid(on elements: [GFElement]) -> Bool
    
    @objc func perform(on elements: [GFElement]) -> [GFElement]
    
}

// MARK: - Translate Action

@objc public class GFActionTranslate: NSObject, GFAction {
    public override init() {
        super.init()
    }
    
    public var byDistance: CGPoint = .zero
    
    @objc public func isValid(on elements: [GFElement]) -> Bool {
        return elements.allSatisfy { element in
            element.type != .none && element.type != .canvas
        }
    }
    
    @objc public func perform(on elements: [GFElement]) -> [GFElement] {
        for element in elements {
            element.position += byDistance
        }
        return elements
    }
}

// MARK: - Duplicate Action

@objc public class GFActionDuplicate: NSObject, GFAction {
    public override init() {
        super.init()
    }
    
    public func isValid(on elements: [GFElement]) -> Bool {
        return elements.allSatisfy { element in
            element.type != .none && element.type != .canvas
        }
    }
    
    public func perform(on elements: [GFElement]) -> [GFElement] {
        var result = elements
        for el in elements {
            if let duplicate = el.createDuplicate() {
                result.append(duplicate)
            }
        }
        return result
    }
    
}

// MARK: - Add Action

@objc public class GFActionAddElement: NSObject, GFAction {
    public override init() {
        super.init()
    }
    
    public var elementsToAdd: [GFElement] = []
    
    public func isValid(on elements: [GFElement]) -> Bool {
        return self.elementsToAdd.allSatisfy { element in
            element.type != .none && element.type != .canvas
        }
    }
    
    public func perform(on elements: [GFElement]) -> [GFElement] {
        return elementsToAdd
    }
}

// MARK: - Delete Action

@objc public class GFActionDelete: NSObject, GFAction {
    public override init() {
        super.init()
    }
    
    public func isValid(on elements: [GFElement]) -> Bool {
        return elements.allSatisfy { element in
            element.type != .none && element.type != .canvas
        }
    }
    
    public func perform(on elements: [GFElement]) -> [GFElement] {
        return []
    }
}

// MARK: - SetFontSize Action

public class GFActionSetFontSize: NSObject, GFAction {
    public override init() {
        super.init()
    }
    
    public var fontSize: CGFloat = 0
    
    public func isValid(on elements: [GFElement]) -> Bool {
        return elements.allSatisfy { element in
            element.type == .text
        }
    }
    
    public func perform(on elements: [GFElement]) -> [GFElement] {
        for el in elements {
            (el as? GFTextElement)?.configure(fontSize: fontSize)
        }
        
        return elements
    }
}

