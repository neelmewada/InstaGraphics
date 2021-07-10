//
//  PexelsPhoto.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 16/05/21.
//

import UIKit

public struct PexelsPhoto: Codable {
    var id: Int
    var width: Int
    var height: Int
    var url: String
    var photographer: String
    var photographerUrl: String
    var photographerId: Int
    var avgColor: String
    var src: URLs
    
    public struct URLs: Codable {
        var original: String
        var large2x: String
        var large: String
        var medium: String
        var small: String
        var portrait: String
        var landscape: String
        var tiny: String
    }
}
