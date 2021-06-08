//
//  GFColor.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 05/05/21.
//

import Foundation
import UIKit

/// A codable color data structure.
public struct GFColor: Codable {
    // MARK: - Properties
    
    public var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0
    
    public var uiColor: UIColor {
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public var cgColor: CGColor {
        return CGColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public static var clear: GFColor {
        return GFColor()
    }
    
    // MARK: - Initializers
    
    public init() {
        
    }
    
    public init(uiColor : UIColor) {
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    }
    
    public init(cgColor : CGColor) {
        self.init(uiColor: UIColor(cgColor: cgColor))
    }
}
