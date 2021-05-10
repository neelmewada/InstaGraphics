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
    var colors: [GFColor] = []
    var locations: [CGFloat] = []
    
    public static var empty: GFGradient {
        return GFGradient()
    }
    
    var cgColors: [CGColor] {
        var cgColors = [CGColor]()
        for color in colors {
            cgColors.append(color.cgColor)
        }
        return cgColors
    }
    
    var numbers: [NSNumber] {
        var numbers = [NSNumber]()
        for floatNumber in locations {
            numbers.append(NSNumber(value: Float(floatNumber)))
        }
        return numbers
    }
}
