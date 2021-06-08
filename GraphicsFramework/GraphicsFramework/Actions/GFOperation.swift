//
//  GFOperation.swift
//  GraphicsFramework
//
//  Created by Neel Mewada on 29/05/21.
//

import UIKit

public struct GFOperation: Codable {
    // MARK: - Init
    
    public init(_ initialState: [GFCodableElement], _ finalState: [GFCodableElement]) {
        self.initialState = initialState
        self.finalState = finalState
    }
    
    // MARK: - Properties
    
    public private(set) var initialState: [GFCodableElement]
    
    public private(set) var finalState: [GFCodableElement]
}
