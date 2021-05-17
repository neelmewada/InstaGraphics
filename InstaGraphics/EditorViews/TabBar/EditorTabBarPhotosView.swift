//
//  EditorTabBarPhotosView.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 06/05/21.
//

import UIKit

class EditorTabBarPhotosView: UIView, EditorTabBarItemView {
    // MARK: - Lifecycle
    
    init() {
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    // MARK: - Properties
    
    private let searchView = EditorTabBarPopupView.SearchView()
    
    private let attributionLabel: UILabel = {
        let label = UILabel()
        label.text = "Photos By: Pexels"
        label.font = UIFont(name: "Roboto-Regular", size: 14)
        label.textColor = UIColor.white.withAlphaComponent(0.3)
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 118, height: 118)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        return view
    }()
    
    private var photoService: PhotoProviderService = PexelsPhotoProviderService()
    private var images: [GFImageInfo] = []
    
    private static let reuseId = "cell"
    
    // MARK: - Configuration
    
    private func configureView() {
        backgroundColor = .clear
        collectionView.backgroundColor = .clear
        
        addSubview(searchView)
        searchView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor)
        
        addSubview(attributionLabel)
        attributionLabel.anchor(top: searchView.bottomAnchor, spacingTop: 18)
        attributionLabel.centerX(inView: self)
        
        addSubview(collectionView)
        collectionView.anchor(top: attributionLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, spacingTop: 24)
        
        collectionView.register(EditorTabBarPhotosThumbnailView.self, forCellWithReuseIdentifier: Self.reuseId)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        photoService.loadDefaultPhotos(atPage: 1, photosPerPage: 30, completion: self.configureData(_:_:))
    }
    
    public func configureOnLayout() {
        
    }
    
    private func configureData(_ images: [GFImageInfo], _ error: Error? = nil) {
        if let error = error {
            print("Error getting images from \(photoService)")
            print("\(error)")
            return
        }
        
        self.images = images
        self.collectionView.reloadData()
    }
}


// MARK: - UICollectionViewDataSource

extension EditorTabBarPhotosView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.reuseId, for: indexPath) as! EditorTabBarPhotosThumbnailView
        cell.configureData(images[indexPath.item])
        return cell
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension EditorTabBarPhotosView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 118, height: 118)
    }
}
