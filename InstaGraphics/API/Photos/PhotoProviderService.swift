//
//  PhotoProviderService.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 16/05/21.
//

import UIKit
import GraphicsFramework

public class PhotoProviderService {
    
    internal init() {
        
    }
    
    // MARK: - Properties
    
    
    
    // MARK: - Methods
    
    func canLoadDefaultPhotos() -> Bool {
        return false
    }
    
    func loadDefaultPhotos(atPage page: Int, photosPerPage: Int, completion: @escaping (Int, [GFImageInfo], Error?) -> ()) {
        
    }
    
}