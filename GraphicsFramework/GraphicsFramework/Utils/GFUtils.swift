//
//  GFUtils.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 06/05/21.
//

import UIKit

class GFUtils {
    public static var orientationWidth: CGFloat {
        let windowScene = UIApplication.shared.getKeyWindow()?.windowScene
        if (windowScene?.interfaceOrientation.isLandscape ?? false) {
            return UIScreen.main.bounds.height
        }
        return UIScreen.main.bounds.width
    }
    
    public static var orientationHeight: CGFloat {
        let windowScene = UIApplication.shared.getKeyWindow()?.windowScene
        if (windowScene?.interfaceOrientation.isLandscape ?? false) {
            return UIScreen.main.bounds.width
        }
        return UIScreen.main.bounds.height
    }
}

// MARK: - Weak<T>

public struct Weak<T> where T: AnyObject {
    private weak var _value: T?
    
    public init(_ value: T) {
        self._value = value
    }
    
    public var value: T? {
        return _value
    }
}

extension Weak: Equatable where T: Equatable {
    public static func == (lhs: Weak<T>, rhs: Weak<T>) -> Bool {
        return lhs.value == rhs.value
    }
    
    public static func == (lhs: Weak<T>, rhs: T) -> Bool {
        return lhs.value == rhs
    }
    
    public static func == (lhs: T, rhs: Weak<T>) -> Bool {
        return lhs == rhs.value
    }
}

