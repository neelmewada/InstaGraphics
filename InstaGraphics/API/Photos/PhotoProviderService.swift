//
//  PhotoProviderService.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 16/05/21.
//

import UIKit
import GraphicsFramework

public protocol PhotoProviderService {
    // MARK: - Methods
    
    func canLoadDefaultPhotos() -> Bool
    
    func loadDefaultPhotos(atPage page: Int, photosPerPage: Int, completion: @escaping (Int, [GFCodableImage], Error?) -> ())
    
}
