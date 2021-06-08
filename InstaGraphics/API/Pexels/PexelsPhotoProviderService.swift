//
//  PexelsPhotoProviderService.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 16/05/21.
//

import UIKit
import GraphicsFramework

/// Photo Provider Service used to retreive photos from Pexels.
public class PexelsPhotoProviderService: PhotoProviderService {
    
    public init() {
        
    }
    
    // MARK: - Private Properties
    
    private static let API_KEY = "563492ad6f91700001000001c002a18bf1c14c4e86b0acf4158e8031"
    
    private static let baseUrl = "https://api.pexels.com/v1"
    
    private static var curatedPhotosUrl: String {
        return "\(baseUrl)/curated"
    }
    
    // MARK: - Overrides
    
    public func canLoadDefaultPhotos() -> Bool {
        return true
    }
    
    /// Loads a list of curated photos from the Pexels API.
    public func loadDefaultPhotos(atPage page: Int, photosPerPage: Int, completion: @escaping (Int, [GFCodableImage], Error?) -> ()) {
        guard let url = URL(string: "\(Self.curatedPhotosUrl)?page=\(page)&per_page=\(photosPerPage)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(Self.API_KEY, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error loading default photos from Pexels.\n \(error)")
                DispatchQueue.main.async {
                    completion(0, [], error)
                }
                return
            }
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(PexelsCuratedResult.self, from: data)
                
                var images = [GFCodableImage]()
                for photo in result.photos {
                    let urls = photo.src
                    let image = GFCodableImage.create(withMode: .remote,
                                                   thumbnailUrl: .fromString(urls.tiny),
                                                   urls: [.fromString(urls.small),
                                                          .fromString(urls.tiny),
                                                          .fromString(urls.medium),
                                                          .fromString(urls.large),
                                                          .fromString(urls.large2x),
                                                          .fromString(urls.landscape),
                                                          .fromString(urls.portrait),
                                                          .create(urls.original, CGSize(width: photo.width, height: photo.height))])
                    images.append(image)
                }
                
                DispatchQueue.main.async {
                    completion(page, images, nil)
                }
            } catch {
                print("Error fetching default photos from Pexels response. \(error)")
                DispatchQueue.main.async {
                    completion(page, [], error)
                }
                return
            }
        }
        
        task.resume()
    }
}
