//
//  EditorTabBarPhotosView.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 06/05/21.
//

import UIKit
import GraphicsFramework

class EditorTabBarPhotosView: UIView, EditorPopupContentView {
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
        return view
    }()
        
    public weak var delegate: EditorTabBarPhotosViewDelegate? = nil
    
    private var photoService: PhotoProviderService = PexelsPhotoProviderService()
    private var images: [Int: [GFImageInfo]] = [:]
    private var pageNumbersLoadCalled: [Int] = []
    private static let imagesPerPage = 50
    
    private var firstLoadedPage = 1
    
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
        
        loadPage(1)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.collectionView.addGestureRecognizer(tapGesture)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        self.collectionView.addGestureRecognizer(longPressGesture)
    }
    
    public func configureOnLayout() {
        
    }
    
    private func configureData(_ page: Int, _ images: [GFImageInfo], _ error: Error? = nil) {
        if let error = error {
            print("Error getting images from \(photoService)")
            print("\(error)")
            return
        }
        self.images[page] = images
        self.firstLoadedPage = self.images.keys.sorted().first!
        self.collectionView.reloadData()
    }
    
    // MARK: - Methods
    
    private func loadPage(_ page: Int) {
        if !pageNumbersLoadCalled.contains(page) {
            pageNumbersLoadCalled.append(page)
        } else {
            return // No need to fire multiple requests for a single page.
        }
        print("Loading page \(page)")
        
        // Load placeholder/empty images to fill the spots temporarily.
        self.images[page] = [GFImageInfo](repeating: .empty, count: Self.imagesPerPage)
        photoService.loadDefaultPhotos(atPage: page, photosPerPage: Self.imagesPerPage, completion: self.configureData(_:_:_:))
    }
    
    public func setDelegate(_ value: EditorPopupContentViewDelegate) {
        self.delegate = value as? EditorTabBarPhotosViewDelegate
    }
    
    // MARK: - Action
    
    @objc private func handleTap(_ tapGesture: UITapGestureRecognizer) {
        let location = tapGesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: location) else { return }
        guard let cell = self.collectionView.cellForItem(at: indexPath) as? EditorTabBarPhotosThumbnailView else { return }
        
        delegate?.editorTabBarPhotosView(self, didTapOnPhoto: cell.image!)
    }
    
    @objc private func handleLongPress(_ longPressGesture: UILongPressGestureRecognizer) {
        if longPressGesture.state == .began {
            
        }
    }
}


// MARK: - UICollectionViewDataSource

extension EditorTabBarPhotosView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        for page in images {
            count += images[page.key]?.count ?? 0
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.reuseId, for: indexPath) as! EditorTabBarPhotosThumbnailView
        let index = indexPath.item
        let firstPageNumber = firstLoadedPage
        
        let pageNumber = firstPageNumber + index / Self.imagesPerPage
        let indexInPage = index % Self.imagesPerPage
        cell.configureData(images[pageNumber]![indexInPage])
        return cell
    }
}

// MARK: - UIScrollViewDelegate

extension EditorTabBarPhotosView {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let distRemainingY = abs(scrollView.contentOffset.y - scrollView.contentSize.height)
        let lastCell = collectionView.visibleCells.last!
        let lastCellIndex = collectionView.indexPath(for: lastCell)!.item
        
        let firstPageNumber = firstLoadedPage
        let curPageNumber = firstPageNumber + lastCellIndex / Self.imagesPerPage
        
        if distRemainingY < 1000 {
            loadPage(curPageNumber + 1)
        }
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension EditorTabBarPhotosView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 118, height: 118)
    }
}

// MARK: - Delegate

protocol EditorTabBarPhotosViewDelegate: EditorPopupContentViewDelegate {
    func editorTabBarPhotosView(_ view: EditorTabBarPhotosView, didTapOnPhoto photo: GFImageInfo)
    func editorTabBarPhotosViewShouldDismiss(_ view: EditorTabBarPhotosView)
}
