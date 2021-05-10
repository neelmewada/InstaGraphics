//
//  ViewController.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 01/05/21.
//

import UIKit
import CoreGraphics

// This is a TESTING-ONLY ViewController used to experiment with things.

class ViewController: UIViewController, UIGestureRecognizerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    private let canvas = Canvas(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    private let editableView = TestEditableView(frame: CGRect(x: 50, y: 100, width: 250, height: 250))
    
    private var results: [UnspashResult] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        label.isMultipleTouchEnabled = true
        label.isUserInteractionEnabled = true
        label.isHidden = true
        
        // add pan gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        panGesture.delegate = self
        label.addGestureRecognizer(panGesture)
        
        // add pinch gesture
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        pinchGesture.delegate = self
        label.addGestureRecognizer(pinchGesture)
        
        // add rotate gesture
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate))
        rotateGesture.delegate = self
        label.addGestureRecognizer(rotateGesture)
        
        //view.addSubview(canvas)
        
        //view.addSubview(editableView)
        
        collectionView.dataSource = self
        let flowLayout = UICollectionViewFlowLayout()
        
        collectionView.collectionViewLayout = flowLayout
        
        collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
        
        loadData()
    }
    
    @objc func viewTapped() {
        //captureAndScale(to: 1.0)
    }
    
    private func captureAndScale(to scale: CGFloat) {
        let layer = view.layer
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale * 2.0)
        view.drawHierarchy(in: layer.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let ac = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
        present(ac, animated: true, completion: nil)
    }

    @objc private func handlePan(_ recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began || recognizer.state == .changed {
            let translation = recognizer.translation(in: self.view)
            recognizer.view!.center = CGPoint(x: recognizer.view!.center.x + translation.x,
                                              y: recognizer.view!.center.y + translation.y)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
    }
    
    @objc private func handlePinch(_ recognizer: UIPinchGestureRecognizer) {
        if let view = recognizer.view {
            if recognizer.state == .changed {
                view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
                label.font = label.font.withSize(label.font.pointSize + (recognizer.scale - 1) * 50)
                recognizer.scale = 1
            }
        }
    }
    
    @objc private func handleRotate(_ recognizer: UIRotationGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.rotated(by: recognizer.rotation * 1.5)
            recognizer.rotation = 0
        }
    }
    
    func loadData() {
        let url = URL(string: "https://api.unsplash.com/photos?page=1&per_page=30")!
        let token = "zHhi1ICehbo8P7YqtahURWGm77PD042fANnCyM7-laU"
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Client-ID \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            if let error = error {
                print("Error retrieving photos. \(error)")
                return
            }
            guard let data = data else {
                print("[Error] Data is nil")
                return
            }
            do {
                let resultArray = try JSONDecoder().decode([UnspashResult].self, from: data)
                self.results = resultArray
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch {
                print("Error decoding JSON data. \(error)")
            }
        }
        
        task.resume()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let imageView = cell.contentView.subviews.first! as! UIImageView
        let url = URL(string: results[indexPath.item].urls.thumb)!
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageView.image = image
                    }
                }
            }
        }
        return cell
    }
    
    struct UnspashResult: Codable {
        let id: String
        var width: Int
        var height: Int
        var urls: UrlInfo
        
        struct UrlInfo: Codable {
            var raw: String
            var full: String
            var regular: String
            var small: String
            var thumb: String
        }
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

fileprivate class Canvas: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let startPoint = rect.origin
        let endPoint = CGPoint(x: startPoint.x + rect.width, y: startPoint.y + rect.height)
        
        context.move(to: startPoint)
        context.addLine(to: endPoint)
        UIColor.yellow.setStroke()
        UIColor.yellow.setFill()
        context.strokePath()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attributes: [NSAttributedString.Key : Any] = [
            .paragraphStyle: paragraphStyle,
            .font: UIFont.systemFont(ofSize: 12.0),
            .foregroundColor: UIColor.blue
        ]
        
        let myText = "HELLO"
        let attributedString = NSAttributedString(string: myText, attributes: attributes)
        
        let stringRect = rect
        attributedString.draw(in: stringRect)
    }
}

