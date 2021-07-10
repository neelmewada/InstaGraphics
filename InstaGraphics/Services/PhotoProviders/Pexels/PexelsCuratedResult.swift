//
//  PexelsCuratedResult.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 16/05/21.
//

import UIKit

public struct PexelsCuratedResult: Codable {
    var page: Int
    var perPage: Int
    var photos: [PexelsPhoto]
    
    var prevPage: String?
    var nextPage: String?
}
