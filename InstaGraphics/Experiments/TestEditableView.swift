//
//  EditableView.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 02/05/21.
//

import UIKit

class TestEditableView: UIView {
    
    public let imageView = UIImageView(image: UIImage(named: "mock"))
    private let anchorRadius: CGFloat = 10.0
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
        configureView()
    }
    
    private func configureView() {
        self.clipsToBounds = false
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: anchorRadius + 2),
            imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: anchorRadius + 2),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -anchorRadius - 2),
            imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -anchorRadius - 2),
        ])
        
        label.text = "Hello"
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: topAnchor, constant: -10),
            label.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let drawRect = rect.inset(by: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))
        
        let path = UIBezierPath(rect: drawRect)
        UIColor.cyan.setStroke()
        path.lineWidth = 5.0
        path.stroke()
        
        let cornerPoints = [drawRect.origin, CGPoint(x: drawRect.origin.x + drawRect.width, y: drawRect.origin.y), CGPoint(x: drawRect.origin.x, y: drawRect.origin.y + drawRect.height), CGPoint(x: drawRect.origin.x + drawRect.width, y: drawRect.origin.y + drawRect.height)]
        
        UIColor.black.set()
        context.setShadow(offset: .zero, blur: 5, color: UIColor.black.cgColor)
        
        for point in cornerPoints {
            let radius: CGFloat = anchorRadius
            let topLeft = CGPoint(x: point.x - radius, y: point.y - radius)
            let ovalRect = CGRect(origin: topLeft, size: CGSize(width: radius * 2.0, height: radius * 2.0))
            
            let circle = UIBezierPath(ovalIn: ovalRect)
            UIColor.white.setFill()
            UIColor.black.setStroke()
            circle.fill()
            circle.stroke()
        }
    }
}
