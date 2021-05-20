//
//  GFGradient.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 05/05/21.
//

import Foundation
import UIKit

/// A codable gradient data structure.
public struct GFGradient: Codable {
    public var colors: [GFColor] = []
    public var locations: [CGFloat] = []
    
    public static var empty: GFGradient {
        return GFGradient()
    }
    
    public var cgColors: [CGColor] {
        var cgColors = [CGColor]()
        for color in colors {
            cgColors.append(color.cgColor)
        }
        return cgColors
    }
    
    public var numbers: [NSNumber] {
        var numbers = [NSNumber]()
        for floatNumber in locations {
            numbers.append(NSNumber(value: Float(floatNumber)))
        }
        return numbers
    }
    
    public var isEmpty: Bool {
        return locations.count == 0 && colors.count == 0
    }
}
